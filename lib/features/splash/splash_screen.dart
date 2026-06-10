import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/locations.dart';
import 'splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _dotsController;
  Timer? _fadeTimer;
  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔵 SplashScreen: initState called');

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔵 SplashScreen: postFrameCallback - starting animations');
      _entryController.forward();
      _fadeTimer = Timer(const Duration(milliseconds: 2450), () {
        debugPrint('🔵 SplashScreen: fadeTimer - setting fade out');
        if (mounted) {
          setState(() => _isFadingOut = true);
        }
      });

      debugPrint('🔵 SplashScreen: Getting splashControllerProvider');
      final controller = ref.read(splashControllerProvider);
      debugPrint('🔵 SplashScreen: Controller obtained = $controller');

      debugPrint('🔵 SplashScreen: Calling controller.start()');
      controller.start(() {
        debugPrint('🔵 SplashScreen: Navigation callback - about to navigate');

        // Check if mounted and router is available
        if (!mounted) {
          debugPrint('🔵 SplashScreen: ERROR - widget not mounted');
          return;
        }

        // Get router state
        final router = GoRouter.of(context);
        debugPrint('🔵 SplashScreen: Current router instance: $router');

        // Route introspection isn't available on this GoRouter version.
        debugPrint(
            '🔵 SplashScreen: Route listing skipped due to GoRouter API compatibility');

        // Try different navigation methods
        debugPrint('🔵 SplashScreen: Trying context.goNamed("onboarding")');
        try {
          router.goNamed('onboarding');
          debugPrint('🔵 SplashScreen: goNamed successful');
        } catch (e) {
          debugPrint('🔵 SplashScreen: goNamed failed with error: $e');

          // Fallback to path navigation
          debugPrint('🔵 SplashScreen: Trying context.go("/onboarding")');
          try {
            router.go('/onboarding');
            debugPrint('🔵 SplashScreen: go successful');
          } catch (e2) {
            debugPrint('🔵 SplashScreen: go failed with error: $e2');

            // Final fallback - push
            debugPrint('🔵 SplashScreen: Trying context.push("/onboarding")');
            try {
              router.push('/onboarding');
              debugPrint('🔵 SplashScreen: push successful');
            } catch (e3) {
              debugPrint('🔵 SplashScreen: All navigation attempts failed: $e3');
            }
          }
        }
      });
      debugPrint('🔵 SplashScreen: controller.start() call completed');
    });
  }

  @override
  void dispose() {
    debugPrint('🔵 SplashScreen: dispose called');
    _fadeTimer?.cancel();
    _entryController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔵 SplashScreen: build called, isFadingOut=$_isFadingOut');

    return Scaffold(
      backgroundColor: kBackground,
      body: AnimatedOpacity(
        opacity: _isFadingOut ? 0 : 1,
        duration: const Duration(milliseconds: 550),
        curve: Curves.ease,
        child: Stack(
          children: [
            const Positioned.fill(child: _SplashGlow()),
            Center(
              child: AnimatedBuilder(
                animation: _entryController,
                builder: (context, child) {
                  final held = _entryController.value;
                  final scale = 0.85 + (held * 0.15);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: held,
                        child: const _GoldDivider(),
                      ),
                      const SizedBox(height: 22),
                      Transform.scale(
                        scale: scale,
                        child: child,
                      ),
                      const SizedBox(height: 22),
                      Opacity(
                        opacity: held,
                        child: const _GoldDivider(),
                      ),
                    ],
                  );
                },
                child: const _BrandLockup(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 52,
              child: FadeTransition(
                opacity: _entryController,
                child: _LoadingDots(controller: _dotsController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashGlow extends StatelessWidget {
  const _SplashGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, 0.1),
          radius: 0.72,
          colors: [
            kPurple.withValues(alpha: 0.26),
            kPurple.withValues(alpha: 0),
          ],
          stops: const [0, 0.7],
        ),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 108,
          height: 108,
          margin: const EdgeInsets.only(bottom: 22),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: kPurpleLight.withValues(alpha: 0.4),
                blurRadius: 44,
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
                child: Icon(Icons.location_city, color: kGold, size: 58),
              ),
            ),
          ),
        ),
        Text(
          kAppName,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: kCream,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.8,
            shadows: [
              Shadow(
                color: kPurpleLight.withValues(alpha: 0.25),
                blurRadius: 40,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(
          width: 180,
          height: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  kGold,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          kRedemptionCityName.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: kGold,
                fontWeight: FontWeight.w500,
                letterSpacing: 3.3,
              ),
        ),
      ],
    );
  }
}

class _GoldDivider extends StatelessWidget {
  const _GoldDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 48,
      height: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              kGold,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.controller});

  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final phase = (controller.value + (index * 0.16)) % 1;
            final wave = (math.sin(phase * math.pi * 2) + 1) / 2;
            final opacity = 0.2 + (wave * 0.8);
            final scale = 0.8 + (wave * 0.35);

            return Transform.scale(
              scale: scale,
              child: Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: kGold.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
