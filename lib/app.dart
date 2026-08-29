import 'package:flutter/material.dart';
import 'package:meathub/providers/coupon_provider.dart';
import 'package:meathub/providers/orders_provider.dart';
import 'package:meathub/providers/search_history_provider.dart';
import 'package:meathub/providers/ticket_provider.dart';
import 'package:meathub/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_theme.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/providers/cart_provider.dart';
import 'package:meathub/providers/wishlist_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => SearchHistoryProvider()),
      ],
      child: MaterialApp(
        title: 'MeatHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
