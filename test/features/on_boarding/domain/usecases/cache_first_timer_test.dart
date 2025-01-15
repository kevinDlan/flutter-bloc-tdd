import 'package:dartz/dartz.dart';
import 'package:education_app/errors/failure.dart';
import 'package:education_app/features/on_boarding/domain/repositories/on_boarding_repo.dart';
import 'package:education_app/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'onboarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usecase;
  const tErrorMessage = 'Unknow error Occured';
  const tErrorStatusCode = 500;
  setUp(() {
    repo = MockOnboardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  test(
    'should call the [OnboardingRepo.cachedFirstTimer]'
    ' and return the right data',
    () async {
      when(() => repo.cacheFirstTimer()).thenAnswer(
        (_) async => Left(
          ServerFailure(message: tErrorMessage, statusCode: tErrorStatusCode),
        ),
      );

      final result = await usecase();

      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: tErrorMessage,
              statusCode: tErrorStatusCode,
            ),
          ),
        ),
      );

      verify(() => repo.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
