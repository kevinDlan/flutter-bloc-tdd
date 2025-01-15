import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/errors/failure.dart';
import 'package:education_app/features/auth/data/models/user_model.dart';
import 'package:education_app/features/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/features/auth/domain/usecases/sign_in.dart';
import 'package:education_app/features/auth/domain/usecases/sign_up.dart';
import 'package:education_app/features/auth/domain/usecases/update_user.dart';
import 'package:education_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignInParams = SignInParams.empty();
  const tSignUpParams = SignUpParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();
  final tServerFailure =
      ServerFailure(message: 'something wrong', statusCode: 400);

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });

  // clean preview test data
  tearDown(() => authBloc.close());

  setUpAll(() {
    registerFallbackValue(tUpdateUserParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParams);
  });

  test('initialState should be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });

  group('signInEvent', () {
    const tUser = UserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] '
      ' when signIn succeds]',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignInEvent(
            email: tSignUpParams.email,
            password: tSignInParams.password,
          ),
        );
      },
      expect: () => [const AuthLoading(), const SignedIn(tUser)],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] '
      ' when signIn fail',
      build: () {
        when(() => signIn(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignInEvent(
            email: tSignUpParams.email,
            password: tSignInParams.password,
          ),
        );
      },
      expect: () => [const AuthLoading(), AuthError(tServerFailure.message)],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('signUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] '
      ' when signed succeds',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        authBloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            name: tSignUpParams.fullName,
          ),
        );
      },
      expect: () => [
        const AuthLoading(),
        const SignedUp(),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] '
      ' when signed fail',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        authBloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            name: tSignUpParams.fullName,
          ),
        );
      },
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('forgotPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, ForgotPasswordSent]'
      ' when forgotPassword succeed',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(ForgotPasswordEvent(email: tSignUpParams.email));
      },
      expect: () => [const AuthLoading(), const ForgotPasswordSent()],
      verify: (_) {
        verify(() => forgotPassword(tSignUpParams.email)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError]'
      ' when forgotPassword fail',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(ForgotPasswordEvent(email: tSignUpParams.email));
      },
      expect: () => [const AuthLoading(), AuthError(tServerFailure.message)],
      verify: (_) {
        verify(() => forgotPassword(tSignUpParams.email)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('updateUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserUpdated] '
      ' when UpdateUser succeed',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          UpdateUserEvent(
            updateUserAction: tUpdateUserParams.action,
            userData: tUpdateUserParams.userData,
          ),
        );
      },
      expect: () => [const AuthLoading(), const UserUpdated()],
      verify: (_) {
        verify(
          () => updateUser(
            tUpdateUserParams,
          ),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] '
      ' when UpdateUser fails',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          UpdateUserEvent(
            updateUserAction: tUpdateUserParams.action,
            userData: tUpdateUserParams.userData,
          ),
        );
      },
      expect: () => [const AuthLoading(), AuthError(tServerFailure.message)],
      verify: (_) {
        verify(
          () => updateUser(
            tUpdateUserParams,
          ),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
