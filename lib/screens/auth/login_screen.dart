import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/services/auth_service.dart';
import 'package:meathub/core/widgets/auth_header.dart';
import 'package:meathub/core/widgets/auth_scaffold.dart';
import 'package:meathub/core/widgets/custom_button.dart';
import 'package:meathub/core/widgets/or_divider.dart';
import 'package:meathub/core/widgets/social_button.dart';
import 'package:meathub/providers/user_provider.dart';

import '../../core/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final error = await AuthService.signIn(email: email, password: password);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    final user = AuthService.currentUser;
    if (user != null) {
      context.read<UserProvider>().updateProfile(
        name: (user.displayName != null && user.displayName!.isNotEmpty)
            ? user.displayName
            : null,
        email: user.email,
      );
    }

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(),
          const SizedBox(height: 28),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome ',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                TextSpan(
                  text: 'Back!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.loginSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            icon: Icons.mail_outline,
            hint: AppStrings.emailAddressHint,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.lock_outline,
            hint: AppStrings.passwordHint,
            isPassword: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                height: 22,
                width: 22,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                AppStrings.rememberMe,
                style: TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  AppStrings.forgotPasswordLink,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            label: AppStrings.signIn,
            onPressed: _handleSignIn,
            isLoading: _isSubmitting,
          ),
          const SizedBox(height: 20),
          const OrDivider(),
          const SizedBox(height: 16),
          SocialButton(
            label: AppStrings.continueWithGoogle,
            icon: const Icon(
              Icons.g_mobiledata,
              size: 24,
              color: Color(0xFF4285F4),
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          SocialButton(
            label: AppStrings.continueWithFacebook,
            icon: const Icon(
              Icons.facebook,
              size: 20,
              color: Color(0xFF1877F2),
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppStrings.dontHaveAccount,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.signup),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      AppStrings.signUp,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 220),
        ],
      ),
    );
  }
}
