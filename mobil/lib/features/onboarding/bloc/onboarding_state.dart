part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.isShowedBefore,
    this.pageNumber = 0,
  });

  final bool? isShowedBefore;
  final int pageNumber;

  OnboardingState copyWith({
    bool? isShowedBefore,
    int? pageNumber,
  }) {
    return OnboardingState(
      isShowedBefore: isShowedBefore ?? this.isShowedBefore,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object?> get props => [
        isShowedBefore,
        pageNumber,
      ];
}
