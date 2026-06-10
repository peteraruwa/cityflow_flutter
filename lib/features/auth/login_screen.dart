import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  bool _phoneFocused = false;
  bool _passwordFocused = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.8),
            radius: 0.9,
            colors: [
              kPurple.withValues(alpha: 0.28),
              kBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(26, 28, 26, 34),
            children: [
              const SizedBox(height: 32),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CityFlow',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: kCream,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined, color: kGold, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Redemption City',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kGold,
                          letterSpacing: 1.2,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 42),
              // Welcome
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: kCream,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in to continue exploring Redemption City.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kMutedText,
                    ),
              ),
              const SizedBox(height: 32),
              // Phone/Email field
              Focus(
                onFocusChange: (focused) =>
                    setState(() => _phoneFocused = focused),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: kCream),
                  cursorColor: kPurple,
                  decoration: InputDecoration(
                    hintText: 'Phone or email',
                    hintStyle: const TextStyle(color: kMutedText),
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: _phoneFocused ? kPurpleLight : kMutedText,
                    ),
                    filled: true,
                    fillColor: kSurface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: kPurpleLight, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Password field
              Focus(
                onFocusChange: (focused) =>
                    setState(() => _passwordFocused = focused),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  style: const TextStyle(color: kCream),
                  cursorColor: kPurple,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: kMutedText),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: _passwordFocused ? kPurpleLight : kMutedText,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: kMutedText,
                      ),
                    ),
                    filled: true,
                    fillColor: kSurface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: kBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: kPurpleLight, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: kGold),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kPurple, kPurpleDark],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _isLoading ? null : _signIn,
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: kCream,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: kCream,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              // Or divider
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: kBorder),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or continue with',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: kMutedText),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: kBorder),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Social buttons
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SocialButton(
                      label: 'Apple',
                      icon: Icons.apple,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: kMutedText),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: kPurpleLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kCream, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: kCream,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
