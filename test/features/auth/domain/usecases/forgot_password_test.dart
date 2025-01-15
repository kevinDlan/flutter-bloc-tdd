import 'package:dartz/dartz.dart';
import 'package:education_app/features/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo_mock.dart';

void main() {
  late AuthRepoMock authRepoMock;
  late ForgotPassword usecase;

  setUp(() {
    authRepoMock = AuthRepoMock();
    usecase = ForgotPassword(authRepoMock);
  });

  test('should call the [AuthRepo.forgotPassword]', () async {
    when(
      () => authRepoMock.forgotPassword('email'),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase('email');

    expect(
      result,
      equals(
        const Right<dynamic, void>(null),
      ),
    );

    verify(() => authRepoMock.forgotPassword('email')).called(1);
    verifyNoMoreInteractions(authRepoMock);
  });
}
