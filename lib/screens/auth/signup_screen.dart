import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/auth_header.dart';
import 'package:meathub/core/widgets/auth_scaffold.dart';
import 'package:meathub/core/widgets/country_code_chip.dart';
import 'package:meathub/core/widgets/custom_button.dart';
import 'package:meathub/core/widgets/or_divider.dart';
import 'package:meathub/core/widgets/social_button.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _agreeTerms = false;

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
          const CustomTextField(
            icon: Icons.person_outline,
            hint: AppStrings.fullNameHint,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.call_outlined,
            hint: AppStrings.mobileNumberHint,
            keyboardType: TextInputType.phone,
            suffix: const CountryCodeChip(),
          ),
          const SizedBox(height: 14),
          const CustomTextField(
            icon: Icons.mail_outline,
            hint: AppStrings.emailAddressHint,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.lock_outline,
            hint: AppStrings.passwordHint,
            isPassword: true,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.lock_outline,
            hint: AppStrings.confirmPasswordHint,
            isPassword: true,
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
          CustomButton(label: AppStrings.signUp, onPressed: () {}),
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
