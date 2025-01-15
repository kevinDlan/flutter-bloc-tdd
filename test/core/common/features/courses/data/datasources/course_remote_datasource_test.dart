import 'package:education_app/core/common/features/courses/data/datasources/course_remote_datasource.dart';
import 'package:education_app/core/common/features/courses/data/models/course_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  // late CourseRemoteDatasource courseRemoteDatasource;
  late FakeFirebaseFirestore fakeFirebaseFirestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;
  late CourseRemoteDatasourceImpl courseRemoteDatasourceImpl;

  setUp(() async {
    fakeFirebaseFirestore = FakeFirebaseFirestore();

    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'display',
    );

    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credentials);

    storage = MockFirebaseStorage();

    courseRemoteDatasourceImpl = CourseRemoteDatasourceImpl(
      firebaseFirestore: fakeFirebaseFirestore,
      firebaseStorage: storage,
      firebaseAuth: auth,
    );
  });

  group('addCourse', () {
    test('should add the given course to firestore collection', () async {
      //Arrange
      // when(() => )

      final course = CourseModel.empty();
      // Act
      await courseRemoteDatasourceImpl.addCourse(course);

      // Assert
      final fireStoreData =
          await fakeFirebaseFirestore.collection('courses').get();

      expect(fireStoreData.docs.length, 1);

      final courseRef = fireStoreData.docs.first;
      expect(courseRef.data()['id'], courseRef.id);

      final groupData = await fakeFirebaseFirestore.collection('groups').get();
      expect(groupData.docs.length, 1);

      final groupRef = groupData.docs.first;
      expect(groupRef.data()['id'], groupRef.id);

      expect(courseRef.data()['groupId'], groupRef.id);
      expect(groupRef.data()['courseId'], courseRef.id);
    });
  });

  group('getCourse', () {
    test(
      'should return a [List<Course>] when the call is successfull',
      () async {
        final firstDate = DateTime.now();
        final secondDate = DateTime.now().add(const Duration(seconds: 10));
        final expectedCourses = [
          CourseModel.empty().copyWith(createdAt: firstDate),
          CourseModel.empty()
              .copyWith(createdAt: secondDate, id: '1', title: 'Course 1'),
        ];

        for (final course in expectedCourses) {
          // await courseRemoteDatasourceImpl.addCourse(course);
          await fakeFirebaseFirestore.collection('courses').add(course.toMap());
        }

        final result = await courseRemoteDatasourceImpl.getCourses();

        expect(result, expectedCourses);
      },
    );
  });
}
