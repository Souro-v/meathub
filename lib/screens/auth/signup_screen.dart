import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/services/auth_service.dart';
import 'package:meathub/core/widgets/auth_header.dart';
import 'package:meathub/core/widgets/auth_scaffold.dart';
import 'package:meathub/core/widgets/country_code_chip.dart';
import 'package:meathub/core/widgets/custom_button.dart';
import 'package:meathub/core/widgets/or_divider.dart';
import 'package:meathub/core/widgets/social_button.dart';
import 'package:meathub/providers/user_provider.dart';

import '../../core/widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms & Conditions')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final error = await AuthService.signUp(
      email: email,
      password: _passwordController.text,
      name: name,
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    context.read<UserProvider>().updateProfile(
      name: name,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      email: email,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
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
                  text: 'Create ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                TextSpan(
                  text: 'Your ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(
                  text: 'Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.signupSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            icon: Icons.person_outline,
            hint: AppStrings.fullNameHint,
            controller: _nameController,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.call_outlined,
            hint: AppStrings.mobileNumberHint,
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            suffix: const CountryCodeChip(),
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.lock_outline,
            hint: AppStrings.confirmPasswordHint,
            isPassword: true,
            controller: _confirmPasswordController,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 22,
                width: 22,
                child: Checkbox(
                  value: _agreeTerms,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textDark,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            label: AppStrings.signUp,
            onPressed: _handleSignUp,
            isLoading: _isSubmitting,
          ),
          const SizedBox(height: 20),
          const OrDivider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SocialButton(
                  label: AppStrings.continueWithGoogle,
                  icon: const Icon(
                    Icons.g_mobiledata,
                    size: 24,
                    color: Color(0xFF4285F4),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SocialButton(
                  label: AppStrings.continueWithFacebook,
                  icon: const Icon(
                    Icons.facebook,
                    size: 20,
                    color: Color(0xFF1877F2),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppStrings.alreadyHaveAccount,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.login),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      AppStrings.signIn,
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
