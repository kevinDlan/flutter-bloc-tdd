import 'package:dartz/dartz.dart';
import 'package:education_app/features/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/features/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'onboarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    repo = MockOnboardingRepo();
    usecase = CheckIfUserIsFirstTimer(repo);
  });

  test('should get the response from the [MockOnboardingRepo]', () async {
    when(() => repo.checkIfUserIsFirstTimer())
        .thenAnswer((_) async => const Right(true));

    final result = await usecase();

    expect(
      result,
      equals(
        const Right<bool, dynamic>(true),
      ),
    );

    verify(() => repo.checkIfUserIsFirstTimer()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
