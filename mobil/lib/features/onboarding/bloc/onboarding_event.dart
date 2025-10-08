part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class HasBeenShownBefore extends OnboardingEvent {
  const HasBeenShownBefore();
}

class PageChanged extends OnboardingEvent {
  const PageChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object?> get props => [pageIndex];
}

class SetOnboardingShowed extends OnboardingEvent {
  const SetOnboardingShowed();
}
