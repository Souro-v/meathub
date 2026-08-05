import 'package:flutter/material.dart';
import 'package:meathub/screens/splash/splash_screen.dart';
import 'package:meathub/screens/onboarding/onboarding_screen.dart';
import 'package:meathub/screens/auth/login_screen.dart';
import 'package:meathub/screens/auth/signup_screen.dart';
import 'package:meathub/screens/auth/forgot_password_screen.dart';
import 'package:meathub/screens/auth/reset_password_screen.dart';
import 'package:meathub/screens/main/main_screen.dart';

import '../../screens/address/address_selection_screen.dart';
import '../../screens/notification/notification_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String main = '/main';
  static const String notification = '/notification';
  static const String addressSelection = '/address-selection';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    main: (context) => const MainScreen(),
    notification: (context) => const NotificationScreen(),
    addressSelection: (context) => const AddressSelectionScreen(),
  };
}
