import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../shared/widgets/app_screen.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      padding: const EdgeInsets.fromLTRB(26, 28, 26, 34),
      child: Column(
        children: [
          const SizedBox(height: 42),
          Image.asset(
            kRedemptionCityLogoAsset,
            width: 92,
            height: 92,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.location_city,
              color: kGold,
              size: 72,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Welcome Back',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: kCream,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to continue exploring Redemption City.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: kMutedText,
                ),
          ),
          const SizedBox(height: 34),
          const CustomTextField(
            label: 'Email or phone',
            hint: 'you@example.com',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          const CustomTextField(
            label: 'Password',
            hint: 'Enter password',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 18),
          CustomButton(
            label: 'Sign In',
            icon: Icons.arrow_forward,
            onPressed: () => context.goNamed('home'),
          ),
          const SizedBox(height: 18),
          PremiumCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: kGold, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demo access is enabled while backend auth is being connected.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kMutedText,
                          height: 1.35,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
