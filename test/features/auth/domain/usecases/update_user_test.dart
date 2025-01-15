import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/features/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo_mock.dart';

void main() {
  late AuthRepoMock authRepoMock;
  late UpdateUser usecase;

  setUp(() {
    authRepoMock = AuthRepoMock();
    usecase = UpdateUser(authRepoMock);
    registerFallbackValue(UpdateUserAction.email);
  });

  const tUpdateUserAction = UpdateUserAction.email;
  const tUpdateUserParams =
      UpdateUserParams(action: tUpdateUserAction, userData: 'Test email');

  test('should call the [AuthRepo.updateUser]', () async {
    when(
      () => authRepoMock.updateUser(
        action: any(named: 'action'),
        userData: any<dynamic>(named: 'userData'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(tUpdateUserParams);

    expect(
      result,
      equals(
        const Right<dynamic, void>(null),
      ),
    );

    verify(
      () => authRepoMock.updateUser(
        action: tUpdateUserAction,
        userData: 'Test email',
      ),
    ).called(1);
    verifyNoMoreInteractions(authRepoMock);
  });
}
