import 'package:dartz/dartz.dart';
import 'package:education_app/features/auth/domain/entities/user.dart';
import 'package:education_app/features/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo_mock.dart';

void main() {
  late AuthRepoMock authRepoMock;
  late SignIn usecase;
  setUp(() {
    authRepoMock = AuthRepoMock();
    usecase = SignIn(authRepoMock);
  });

  const tEmail = 'email';
  const tPassword = 'password';
  const tUser = LocalUser.empty();
  const params = SignInParams(email: tEmail, password: tPassword);

  test('should return LocalUser from [AuthRepo]', () async {
    when(
      () => authRepoMock.signIn(
        email: any(named: tEmail),
        password: any(named: tPassword),
      ),
    ).thenAnswer((_) async => const Right(tUser));

    final result = await usecase(params);

    expect(
      result,
      equals(
        const Right<dynamic, LocalUser>(tUser),
      ),
    );

    verify(
      () => authRepoMock.signIn(email: tEmail, password: tPassword),
    ).called(1);
    verifyNoMoreInteractions(authRepoMock);
  });
}
