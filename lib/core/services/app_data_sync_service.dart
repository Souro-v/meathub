import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/providers/cart_provider.dart';
import 'package:meathub/providers/orders_provider.dart';
import 'package:meathub/providers/user_provider.dart';
import 'package:meathub/providers/wishlist_provider.dart';

class AppDataSyncService {
  AppDataSyncService._();

  static Future<void> loadAll(BuildContext context) async {
    await Future.wait([
      context.read<CartProvider>().loadFromFirestore(),
      context.read<WishlistProvider>().loadFromFirestore(),
      context.read<OrdersProvider>().loadFromFirestore(),
      context.read<UserProvider>().loadFromFirestore(),
    ]);
  }

  static void resetAll(BuildContext context) {
    context.read<CartProvider>().reset();
    context.read<WishlistProvider>().reset();
    context.read<OrdersProvider>().reset();
    context.read<UserProvider>().reset();
  }
}