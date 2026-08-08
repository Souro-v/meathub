import 'package:flutter/material.dart';
import 'package:meathub/screens/address/add_new_address_sheet.dart';
import 'package:meathub/screens/splash/splash_screen.dart';
import 'package:meathub/screens/onboarding/onboarding_screen.dart';
import 'package:meathub/screens/auth/login_screen.dart';
import 'package:meathub/screens/auth/signup_screen.dart';
import 'package:meathub/screens/auth/forgot_password_screen.dart';
import 'package:meathub/screens/auth/reset_password_screen.dart';
import 'package:meathub/screens/main/main_screen.dart';

import '../../models/product_model.dart';
import '../../screens/address/address_selection_screen.dart';
import '../../screens/address/manage_addresses_screen.dart';
import '../../screens/address/recent_addresses_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/notification/notification_screen.dart';
import '../../screens/product/product_details_screen.dart';
import '../../screens/wishlist/wishlist_screen.dart';

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
  static const String recentAddressesFull = '/recent-addresses';
  static const String addNewAddressSheet = '/addNew-AddressSheet';
  static const String manageAddresses = '/manage-addresses';
  static const String wishlist = '/wishlist';
  static const String cart = '/cart';

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
    recentAddressesFull: (context) => const RecentAddressesScreen(),
    addNewAddressSheet: (context) => const AddNewAddressSheet(),
    manageAddresses: (context) => const ManageAddressesScreen(),
    wishlist: (context) => const WishlistScreen(),
    cart: (context) => const CartScreen(),
  };

  static Route<dynamic> productDetailsRoute(ProductModel product) {
    return MaterialPageRoute(
      builder: (_) => ProductDetailsScreen(product: product),
    );
  }
}
