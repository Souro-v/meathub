import 'package:flutter/material.dart';
import 'package:meathub/screens/address/add_new_address_sheet.dart';
import 'package:meathub/screens/splash/splash_screen.dart';
import 'package:meathub/screens/onboarding/onboarding_screen.dart';
import 'package:meathub/screens/auth/login_screen.dart';
import 'package:meathub/screens/auth/signup_screen.dart';
import 'package:meathub/screens/auth/forgot_password_screen.dart';
import 'package:meathub/screens/auth/reset_password_screen.dart';
import 'package:meathub/screens/main/main_screen.dart';
import '../../models/address_model.dart';
import '../../models/cart_item_model.dart';
import '../../models/delivery_option_model.dart';
import '../../models/payment_method_model.dart';
import '../../models/product_model.dart';
import '../../screens/address/address_selection_screen.dart';
import '../../screens/address/manage_addresses_screen.dart';
import '../../screens/address/recent_addresses_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/checkout/checkout_screen.dart';
import '../../screens/checkout/order_success_screen.dart';
import '../../screens/checkout/payment_screen.dart';
import '../../screens/checkout/place_order_screen.dart';
import '../../screens/notification/notification_screen.dart';
import '../../screens/orders/track_order_screen.dart';
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
    main: (context) => MainScreen(
      initialIndex: (ModalRoute.of(context)?.settings.arguments as int?) ?? 0,
    ),
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

  static Route<dynamic> checkoutRoute(List<CartItemModel> items) {
    return MaterialPageRoute(builder: (_) => CheckoutScreen(items: items));
  }

  static Route<dynamic> paymentRoute({
    required List<CartItemModel> items,
    required DeliveryOptionModel deliveryOption,
    required ManagedAddressModel address,
    required double platformFee,
  }) {
    return MaterialPageRoute(
      builder: (_) => PaymentScreen(
        items: items,
        deliveryOption: deliveryOption,
        address: address,
        platformFee: platformFee,
      ),
    );
  }

  static Route<dynamic> placeOrderRoute({
    required List<CartItemModel> items,
    required DeliveryOptionModel deliveryOption,
    required ManagedAddressModel address,
    required double platformFee,
    required PaymentMethodModel paymentMethod,
  }) {
    return MaterialPageRoute(
      builder: (_) => PlaceOrderScreen(
        items: items,
        deliveryOption: deliveryOption,
        address: address,
        platformFee: platformFee,
        paymentMethod: paymentMethod,
      ),
    );
  }

  static Route<dynamic> orderSuccessRoute({
    required String orderId,
    required DateTime placedAt,
    required List<CartItemModel> items,
    required DeliveryOptionModel deliveryOption,
    required ManagedAddressModel address,
    required double platformFee,
    required PaymentMethodModel paymentMethod,
  }) {
    return MaterialPageRoute(
      builder: (_) => OrderSuccessScreen(
        orderId: orderId,
        placedAt: placedAt,
        items: items,
        deliveryOption: deliveryOption,
        address: address,
        platformFee: platformFee,
        paymentMethod: paymentMethod,
      ),
    );
  }

  static Route<dynamic> trackOrderRoute({
    required String orderId,
    required DateTime placedAt,
    required List<CartItemModel> items,
    required ManagedAddressModel address,
    required DeliveryOptionModel deliveryOption,
    required PaymentMethodModel paymentMethod,
    required double platformFee,
  }) {
    return MaterialPageRoute(
      builder: (_) => TrackOrderScreen(
        orderId: orderId,
        placedAt: placedAt,
        items: items,
        address: address,
        deliveryOption: deliveryOption,
        paymentMethod: paymentMethod,
        platformFee: platformFee,
      ),
    );
  }
}
