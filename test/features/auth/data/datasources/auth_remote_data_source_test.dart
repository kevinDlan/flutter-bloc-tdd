// import 'package:education_app/core/enums/update_user_action.dart';
// import 'package:education_app/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

// void main() {
//   late FakeFirebaseFirestore cloudStoreClient;
//   late MockFirebaseAuth authClient;
//   late MockFirebaseStorage dbClient;
//   late AuthRemoteDataSource dataSource;
//   setUp(() async {
//     cloudStoreClient = FakeFirebaseFirestore();
//     final googleSignIn = MockGoogleSignIn();
//     final signInAccount = await googleSignIn.signIn();
//     final googleAuth = await signInAccount!.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     // Sign in.
//     final mockUser = MockUser(
//       uid: 'someuid',
//       email: 'bob@somedomain.com',
//       displayName: 'Bob',
//     );
//     authClient = MockFirebaseAuth(mockUser: mockUser);
//     final result = await authClient.signInWithCredential(credential);
//     final user = result.user;

//     dbClient = MockFirebaseStorage();
//     dataSource = AuthRemoteDataSourceImpl(
//       authClient: authClient,
//       cloudStoreClient: cloudStoreClient,
//       dbClient: dbClient,
//     );
//   });

//   const tEmail = 'test@gmail.com';
//   const tPassword = 'password';
//   const tFullName = 'testor';

//   test('signUp', () async {
//     await dataSource.signUp(
//       email: tEmail,
//       password: tPassword,
//       fullName: tFullName,
//     );

//     expect(authClient.currentUser, isNotNull);
//     expect(authClient.currentUser!.displayName, tFullName);

//     final user = await cloudStoreClient
//         .collection('users')
//         .doc(authClient.currentUser!.uid)
//         .get();

//     expect(user.exists, isTrue);
//   });

//   test('signIn', () async {
//     await dataSource.signUp(
//       email: 'newmail@gmail.com',
//       password: tPassword,
//       fullName: tFullName,
//     );
//     await authClient.signOut();
//     await dataSource.signIn(email: 'newmail@gmail.com', password: tPassword);

//     expect(authClient.currentUser, isNotNull);
//     expect(authClient.currentUser!.email, 'newmail@gmail.com');
//   });

//   group('updateUser', () {
//     test('displayName', () async {
//       await dataSource.signUp(
//         email: tEmail,
//         password: tPassword,
//         fullName: tFullName,
//       );

//       await dataSource.updateUser(
//         action: UpdateUserAction.displayName,
//         userData: 'new name',
//       );

//       expect(authClient.currentUser!.displayName, equals('new name'));
//     });

//     test('email', () async {
//       await dataSource.signUp(
//         email: tEmail,
//         password: tPassword,
//         fullName: tFullName,
//       );

//       await dataSource.updateUser(
//         action: UpdateUserAction.email,
//         userData: 'user@gmail.com',
//       );

//       expect(
//         authClient.currentUser!.email,
//         equals('user@gmail.com'),
//       );
//     });
//   });
// }

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/errors/exceptions.dart';
import 'package:education_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/features/auth/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late UserCredential userCredential;
  late DocumentReference<DataMap> documentReference;
  late MockUser mockUser;

  const tUser = UserModel.empty();

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    documentReference = cloudStoreClient.collection('users').doc();
    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );
    dbClient = MockFirebaseStorage();
    mockUser = MockUser()..uid = documentReference.id;
    userCredential = MockUserCredential(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );

    when(() => authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'Test password';
  const tFullName = 'Test full name';
  const tEmail = 'Test email';

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );
  group('forgotPassword', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => Future.value());

        final call = dataSource.forgotPassword(tEmail);

        expect(call, completes);

        verify(() => authClient.sendPasswordResetEmail(email: tEmail))
            .called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.forgotPassword;

        expect(() => call(tEmail), throwsA(isA<ServerException>()));

        verify(() => authClient.sendPasswordResetEmail(email: tEmail))
            .called(1);
        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUserModel] when no [Exception] is thrown',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        final result = await dataSource.signIn(
          email: tEmail,
          password: tPassword,
        );
        expect(result.uid, userCredential.user!.uid);
        expect(result.point, 0);
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when user is null after signing in',
      () async {
        final emptyUserCredential = MockUserCredential();
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => emptyUserCredential);

        final call = dataSource.signIn;

        expect(
          () => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()),
        );
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is '
      'thrown',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.signIn;

        expect(
          () => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()),
        );
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('signUp', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        when(() => userCredential.user?.updateDisplayName(any())).thenAnswer(
          (_) async => Future.value(),
        );

        when(() => userCredential.user?.updatePhotoURL(any())).thenAnswer(
          (_) async => Future.value(),
        );

        final call = dataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        );

        expect(call, completes);

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        await untilCalled(() => userCredential.user?.updateDisplayName(any()));
        await untilCalled(() => userCredential.user?.updatePhotoURL(any()));

        verify(() => userCredential.user?.updateDisplayName(tFullName))
            .called(1);
        verify(() => userCredential.user?.updatePhotoURL(kDefaultAvatar))
            .called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.signUp;

        expect(
          () => call(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
      },
    );
  });

  group('updateUser', () {
    setUp(() {
      registerFallbackValue(MockAuthCredential());
    });
    test(
      'should update user displayName successfully when no [Exception] is '
      'thrown',
      () async {
        when(() => mockUser.updateDisplayName(any())).thenAnswer(
          (_) async => Future.value(),
        );

        await dataSource.updateUser(
          action: UpdateUserAction.displayName,
          userData: tFullName,
        );

        verify(() => mockUser.updateDisplayName(tFullName)).called(1);

        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final userData =
            await cloudStoreClient.collection('users').doc(mockUser.uid).get();

        expect(userData.data()!['fullName'], tFullName);
      },
    );

    test(
      'should update user email successfully when no [Exception] '
      'is thrown',
      () async {
        when(() => mockUser.verifyBeforeUpdateEmail(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.email,
          userData: tEmail,
        );

        verify(() => mockUser.verifyBeforeUpdateEmail(tEmail)).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final user =
            await cloudStoreClient.collection('users').doc(mockUser.uid).get();

        expect(user.data()!['email'], tEmail);
      },
    );

    test(
      'should update user bio successfully when no [Exception] '
      'is thrown',
      () async {
        const newBio = 'new bio';

        await dataSource.updateUser(
          action: UpdateUserAction.bio,
          userData: newBio,
        );
        final user = await cloudStoreClient
            .collection('users')
            .doc(
              documentReference.id,
            )
            .get();

        expect(user.data()!['bio'], newBio);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));
      },
    );

    test(
      'should update user password successfully when no [Exception] is '
      'thrown',
      () async {
        when(() => mockUser.updatePassword(any())).thenAnswer(
          (_) async => Future.value(),
        );

        when(() => mockUser.reauthenticateWithCredential(any()))
            .thenAnswer((_) async => userCredential);

        when(() => mockUser.email).thenReturn(tEmail);

        await dataSource.updateUser(
          action: UpdateUserAction.password,
          userData: jsonEncode({
            'oldPassword': 'oldPassword',
            'newPassword': tPassword,
          }),
        );

        verify(() => mockUser.updatePassword(tPassword));

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));

        final user = await cloudStoreClient
            .collection('users')
            .doc(
              documentReference.id,
            )
            .get();

        expect(user.data()!['password'], null);
      },
    );

    test(
      'should update user profilePic successfully when no [Exception] is '
      'thrown',
      () async {
        final newProfilePic = File('assets/images/onBoarding_background.png');

        when(() => mockUser.updatePhotoURL(any())).thenAnswer(
          (_) async => Future.value(),
        );

        await dataSource.updateUser(
          action: UpdateUserAction.profilePic,
          userData: newProfilePic,
        );

        verify(() => mockUser.updatePhotoURL(any())).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));

        expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
      },
    );
  });
}
