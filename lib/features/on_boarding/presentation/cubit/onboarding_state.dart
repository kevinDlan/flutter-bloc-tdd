part of 'onboarding_cubit.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class CachingFirstTimer extends OnboardingState {
  const CachingFirstTimer();
}

final class CheckingIfUserIsFirstTimer extends OnboardingState {
  const CheckingIfUserIsFirstTimer();
}

final class UserCached extends OnboardingState {
  const UserCached();
}

class OnboardingStatus extends OnboardingState {
  const OnboardingStatus({required this.isFirstTimer});

  final bool isFirstTimer;

  @override
  List<bool> get props => [isFirstTimer];
}

class OnboardingError extends OnboardingState {
  const OnboardingError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
