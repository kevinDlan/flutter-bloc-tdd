import 'package:dartz/dartz.dart';
import 'package:education_app/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo_mock.dart';

void main() {
  late AuthRepoMock authRepoMock;
  late SignUp usecase;

  setUp(() {
    authRepoMock = AuthRepoMock();
    usecase = SignUp(authRepoMock);
  });

  const tEmail = 'email';
  const tPassword = 'password';
  const tFullName = 'fullName';
  const params = SignUpParams(
    email: tEmail,
    password: tPassword,
    fullName: tFullName,
  );

  test('should call the [AuthRepo.signUp]', () async {
    when(
      () => authRepoMock.signUp(
        email: any(named: tEmail),
        password: any(named: tPassword),
        fullName: any(named: tFullName),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(params);

    expect(
      result,
      equals(
        const Right<dynamic, void>(null),
      ),
    );

    verify(
      () => authRepoMock.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    ).called(1);
    verifyNoMoreInteractions(authRepoMock);
  });
}
