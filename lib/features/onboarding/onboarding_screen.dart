import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../shared/widgets/custom_button.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final copy = _localizedCopy[state.languageCode] ?? _localizedCopy['en']!;
    final step = state.step.clamp(0, 3);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: -90,
            left: 0,
            right: 0,
            child: Center(child: _TopGlow()),
          ),
          Positioned.fill(
            child: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: step == 0
                    ? _LanguageSelection(copy: copy, state: state)
                    : _FeatureSlides(copy: copy, step: step),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSelection extends ConsumerWidget {
  const _LanguageSelection({
    required this.copy,
    required this.state,
  });

  final _OnboardingCopy copy;
  final OnboardingState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      key: const ValueKey('language'),
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _LogoMark(size: 84, marginBottom: 20),
                    Text(
                      copy.welcome,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: kCream,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.4,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      copy.chooseLanguage,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kMutedText,
                            fontSize: 12.5,
                          ),
                    ),
                    const SizedBox(height: 26),
                    ..._languages.map(
                      (language) => Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: _LanguageTile(
                          language: language,
                          isActive: state.languageCode == language.code,
                          onTap: () {
                            ref
                                .read(onboardingControllerProvider.notifier)
                                .setLanguage(language.code);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 34),
            child: CustomButton(
              label: copy.continueLabel,
              icon: Icons.arrow_forward,
              onPressed: () {
                ref.read(onboardingControllerProvider.notifier).setStep(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureSlides extends ConsumerWidget {
  const _FeatureSlides({
    required this.copy,
    required this.step,
  });

  final _OnboardingCopy copy;
  final int step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slide = copy.slides[step - 1];
    final visual = _slideVisuals[step - 1];

    return Padding(
      key: ValueKey('slide-$step'),
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                onPressed: () {
                  context.goNamed('login');
                },
                child: Text(
                  copy.skip,
                  style: const TextStyle(
                    color: kMutedText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Column(
                  key: ValueKey(step),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SlideIcon(visual: visual),
                    const SizedBox(height: 30),
                    Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: kCream,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Text(
                        slide.body,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: kMutedText,
                              fontSize: 13,
                              height: 1.7,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 34),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => _StepDot(
                      isActive: step == index + 1,
                      onTap: () {
                        ref
                            .read(onboardingControllerProvider.notifier)
                            .setStep(index + 1);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: step < 3 ? copy.next : copy.start,
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    if (step < 3) {
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .nextStep();
                      return;
                    }
                    context.goNamed('login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isActive,
    required this.onTap,
  });

  final _LanguageOption language;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? kPurple.withValues(alpha: 0.14) : kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? kPurpleLight.withValues(alpha: 0.6) : kBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isActive
                    ? kPurpleLight.withValues(alpha: 0.22)
                    : kSurfaceHigh,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color:
                      isActive ? kPurpleLight.withValues(alpha: 0.45) : kBorder,
                ),
              ),
              child: Center(
                child: Text(
                  language.code.toUpperCase(),
                  style: TextStyle(
                    color: isActive ? kPurpleLight : kMutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.native,
                    style: const TextStyle(
                      color: kCream,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    language.name,
                    style: const TextStyle(
                      color: kMutedText,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isActive ? kPurpleLight : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? kPurpleLight : kDimText,
                  width: 1.5,
                ),
              ),
              child: isActive
                  ? const Icon(Icons.check, color: kCream, size: 11)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideIcon extends StatelessWidget {
  const _SlideIcon({required this.visual});

  final _SlideVisual visual;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: visual.color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: visual.color.withValues(alpha: 0.19)),
        boxShadow: [
          BoxShadow(
            color: visual.color.withValues(alpha: 0.19),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Icon(
        visual.icon,
        size: 46,
        color: visual.color,
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.isActive,
    required this.onTap,
  });

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isActive ? 22 : 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isActive ? kGold : kDimText,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({
    required this.size,
    required this.marginBottom,
  });

  final double size;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.only(bottom: marginBottom),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kPurpleLight.withValues(alpha: 0.35),
            blurRadius: 36,
          ),
          BoxShadow(
            color: kCream.withValues(alpha: 0.12),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          kRedemptionCityLogoAsset,
          fit: BoxFit.contain,
          semanticLabel: 'Redemption City of God logo',
          errorBuilder: (_, __, ___) => const ColoredBox(
            color: kSurfaceHigh,
            child: Icon(Icons.location_city, color: kGold),
          ),
        ),
      ),
    );
  }
}

class _TopGlow extends StatelessWidget {
  const _TopGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            kPurple.withValues(alpha: 0.2),
            kPurple.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.name,
    required this.native,
  });

  final String code;
  final String name;
  final String native;
}

class _OnboardingCopy {
  const _OnboardingCopy({
    required this.welcome,
    required this.chooseLanguage,
    required this.continueLabel,
    required this.skip,
    required this.next,
    required this.start,
    required this.slides,
  });

  final String welcome;
  final String chooseLanguage;
  final String continueLabel;
  final String skip;
  final String next;
  final String start;
  final List<_OnboardingSlide> slides;
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class _SlideVisual {
  const _SlideVisual({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;
}

const _languages = [
  _LanguageOption(code: 'en', name: 'English', native: 'English'),
  _LanguageOption(code: 'fr', name: 'French', native: 'Francais'),
  _LanguageOption(code: 'yo', name: 'Yoruba', native: 'Yoruba'),
];

const _localizedCopy = {
  'en': _OnboardingCopy(
    welcome: 'Welcome to CityFlow',
    chooseLanguage: 'Choose your language',
    continueLabel: 'Continue',
    skip: 'Skip',
    next: 'Next',
    start: 'Get Started',
    slides: [
      _OnboardingSlide(
        title: 'Navigate the City',
        body: 'Live maps, directions and guided tours across Redemption City.',
      ),
      _OnboardingSlide(
        title: 'Book CityRides',
        body: 'Shuttles and rides between camp zones in just a few taps.',
      ),
      _OnboardingSlide(
        title: 'Everything in One Place',
        body:
            'Events, lost & found, emergency help and more - all in CityFlow.',
      ),
    ],
  ),
  'fr': _OnboardingCopy(
    welcome: 'Bienvenue sur CityFlow',
    chooseLanguage: 'Choisissez votre langue',
    continueLabel: 'Continuer',
    skip: 'Passer',
    next: 'Suivant',
    start: 'Commencer',
    slides: [
      _OnboardingSlide(
        title: 'Naviguez dans la ville',
        body:
            'Cartes en direct, itineraires et visites guidees dans toute la ville.',
      ),
      _OnboardingSlide(
        title: 'Reservez des trajets',
        body: 'Navettes et trajets entre les zones du camp en quelques gestes.',
      ),
      _OnboardingSlide(
        title: 'Tout au meme endroit',
        body:
            'Evenements, objets trouves, aide urgente et plus - tout dans CityFlow.',
      ),
    ],
  ),
  'yo': _OnboardingCopy(
    welcome: 'Kaabo si CityFlow',
    chooseLanguage: 'Yan ede re',
    continueLabel: 'Tesiwaju',
    skip: 'Fo koja',
    next: 'Tokan',
    start: 'Bere',
    slides: [
      _OnboardingSlide(
        title: 'Rin irin ajo ilu',
        body: 'Aworan ile alaye ati itosona jakejado Ilu Irapada.',
      ),
      _OnboardingSlide(
        title: 'Gba oko CityRide',
        body: 'Oko ajo ati irin-ajo laarin agbegbe ago pelu ite die.',
      ),
      _OnboardingSlide(
        title: 'Ohun gbogbo ni ibi kan',
        body:
            'Isele, ohun to sonu, iranlowo pajawiri ati bee bee lo ninu CityFlow.',
      ),
    ],
  ),
};

const _slideVisuals = [
  _SlideVisual(icon: Icons.navigation_outlined, color: kPurple),
  _SlideVisual(icon: Icons.directions_car_outlined, color: kGold),
  _SlideVisual(icon: Icons.bolt_outlined, color: kPurpleLight),
];
