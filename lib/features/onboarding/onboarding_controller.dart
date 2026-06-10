import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

class OnboardingState {
  const OnboardingState({
    required this.languageCode,
    required this.step,
  });

  final String languageCode;
  final int step;

  OnboardingState copyWith({
    String? languageCode,
    int? step,
  }) {
    return OnboardingState(
      languageCode: languageCode ?? this.languageCode,
      step: step ?? this.step,
    );
  }
}

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState(
      languageCode: 'en',
      step: 0,
    );
  }

  void setLanguage(String code) {
    state = state.copyWith(languageCode: code);
  }

  void setStep(int step) {
    state = state.copyWith(step: step);
  }

  void nextStep() {
    state = state.copyWith(step: state.step + 1);
  }
}
