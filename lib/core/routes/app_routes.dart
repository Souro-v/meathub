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
import '../../screens/help/faq_screen.dart';
import '../../screens/help/help_category_screen.dart';
import '../../screens/help/live_chat_screen.dart';
import '../../screens/help/manage_order_screen.dart';
import '../../screens/help/refund_request_screen.dart';
import '../../screens/help/report_issue_screen.dart';
import '../../screens/help/ticket_detail_screen.dart';
import '../../screens/help/ticket_list_screen.dart';
import '../../screens/notification/notification_screen.dart';
import '../../screens/orders/track_order_screen.dart';
import '../../screens/product/product_details_screen.dart';
import '../../screens/profile/about/contact_us_detail_screen.dart';
import '../../screens/profile/about/healthier_future_detail_screen.dart';
import '../../screens/profile/about/our_mission_detail_screen.dart';
import '../../screens/profile/about/our_story_detail_screen.dart';
import '../../screens/profile/about/our_values_detail_screen.dart';
import '../../screens/profile/about/our_vision_detail_screen.dart';
import '../../screens/profile/about/thank_you_detail_screen.dart';
import '../../screens/profile/about/what_makes_us_different_detail_screen.dart';
import '../../screens/profile/about_meathub_screen.dart';
import '../../screens/profile/all_offers_screen.dart';
import '../../screens/profile/coupons_offers_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/help_support_screen.dart';
import '../../screens/profile/how_it_works_screen.dart';
import '../../screens/profile/meathub_guarantee_screen.dart';
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
  static const String editProfile = '/edit-profile';
  static const String couponsOffers = '/coupons-offers';
  static const String allOffers = '/all-offers';
  static const String howItWorks = '/how-it-works';
  static const String meatHubGuarantee = '/meathub-guarantee';
  static const String helpSupport = '/help-support';
  static const String faqScreen = '/faq';
  static const String ticketList = '/ticket-list';
  static const String liveChat = '/live-chat';
  static const String aboutMeatHub = '/about-meathub';
  static const String ourStoryDetail = '/about/our-story';
  static const String ourMissionDetail = '/about/our-mission';
  static const String ourVisionDetail = '/about/our-vision';
  static const String whatMakesUsDifferentDetail =
      '/about/what-makes-us-different';
  static const String ourValuesDetail = '/about/our-values';
  static const String contactUsDetail = '/about/contact-us';
  static const String healthierFutureDetail = '/about/healthier-future';
  static const String thankYouDetail = '/about/thank-you';

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
    editProfile: (context) => const EditProfileScreen(),
    couponsOffers: (context) => const CouponsOffersScreen(),
    allOffers: (context) => const AllOffersScreen(),
    howItWorks: (context) => const HowItWorksScreen(),
    meatHubGuarantee: (context) => const MeatHubGuaranteeScreen(),
    helpSupport: (context) => const HelpSupportScreen(),
    faqScreen: (context) => const FaqScreen(),
    ticketList: (context) => const TicketListScreen(),
    liveChat: (context) => const LiveChatScreen(),
    aboutMeatHub: (context) => const AboutMeatHubScreen(),
    ourStoryDetail: (context) => const OurStoryDetailScreen(),
    ourMissionDetail: (context) => const OurMissionDetailScreen(),
    ourVisionDetail: (context) => const OurVisionDetailScreen(),
    whatMakesUsDifferentDetail: (context) =>
        const WhatMakesUsDifferentDetailScreen(),
    ourValuesDetail: (context) => const OurValuesDetailScreen(),
    contactUsDetail: (context) => const ContactUsDetailScreen(),
    healthierFutureDetail: (context) => const HealthierFutureDetailScreen(),
    thankYouDetail: (context) => const ThankYouDetailScreen(),
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

  static Route<dynamic> allOffersRoute({String initialTag = 'all'}) {
    return MaterialPageRoute(
      builder: (_) => AllOffersScreen(initialTag: initialTag),
    );
  }

  static Route<dynamic> helpCategoryRoute(String topicKey) {
    return MaterialPageRoute(
      builder: (_) => HelpCategoryScreen(topicKey: topicKey),
    );
  }

  static Route<dynamic> ticketDetailRoute(String ticketId) {
    return MaterialPageRoute(
      builder: (_) => TicketDetailScreen(ticketId: ticketId),
    );
  }

  static Route<dynamic> reportIssueRoute({
    String? orderId,
    String? presetIssueType,
  }) {
    return MaterialPageRoute(
      builder: (_) =>
          ReportIssueScreen(orderId: orderId, presetIssueType: presetIssueType),
    );
  }

  static Route<dynamic> refundRequestRoute(String orderId) {
    return MaterialPageRoute(
      builder: (_) => RefundRequestScreen(orderId: orderId),
    );
  }

  static Route<dynamic> manageOrderRoute(String orderId) {
    return MaterialPageRoute(
      builder: (_) => ManageOrderScreen(orderId: orderId),
    );
  }
}
