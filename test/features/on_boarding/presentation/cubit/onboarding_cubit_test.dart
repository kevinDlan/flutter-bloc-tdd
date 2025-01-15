import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/errors/failure.dart';
import 'package:education_app/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/features/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/features/on_boarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnboardingCubit cubit;
  const tErrorMessage = 'Insufficient storage';

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    cubit = OnboardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  test('initial state should be [Onboarding init state]', () {
    expect(cubit.state, const OnboardingInitial());
  });

  group('cacheFirstTimer', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CachingFirstTimer, UserCached]',
      build: () {
        when(() => cacheFirstTimer())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const [
        CachingFirstTimer(),
        UserCached(),
      ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CachingFirstTimer, OnboardingError]',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer(
          (_) async => Left(
            CacheFailure(
              message: tErrorMessage,
              statusCode: 4032,
            ),
          ),
        );

        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => [
        const CachingFirstTimer(),
        const OnboardingError(tErrorMessage),
      ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CheckingIfUserIsFirstTimer, '
      'OnBoardingStatus] when successful',
      build: () {
        when(() => checkIfUserIsFirstTimer()).thenAnswer(
          (_) async => const Right(false),
        );
        return cubit;
      },
      act: (cubic) => cubic.checkIfUserIsFirstTimer(),
      expect: () => const [
        CheckingIfUserIsFirstTimer(),
        OnboardingStatus(isFirstTimer: false),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CheckingIfUserIsFirstTimer, '
      'OnboardingStatus[true] ] when fail',
      build: () {
        when(() => checkIfUserIsFirstTimer()).thenAnswer(
          (_) async => Left(
            CacheFailure(message: tErrorMessage, statusCode: 4032),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
