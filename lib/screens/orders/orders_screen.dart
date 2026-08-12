import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/order_list_card.dart';
import 'package:meathub/models/order_model.dart';
import 'package:meathub/providers/cart_provider.dart';
import 'package:meathub/providers/orders_provider.dart';

enum _OrderTab { all, ongoing, delivered, cancelled, returned }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  _OrderTab _selectedTab = _OrderTab.all;
  bool _newestFirst = true;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const List<Map<String, dynamic>> _tabs = [
    {'tab': _OrderTab.all, 'label': AppStrings.ordersTabAll},
    {'tab': _OrderTab.ongoing, 'label': AppStrings.ordersTabOngoing},
    {'tab': _OrderTab.delivered, 'label': AppStrings.ordersTabDelivered},
    {'tab': _OrderTab.cancelled, 'label': AppStrings.ordersTabCancelled},
    {'tab': _OrderTab.returned, 'label': AppStrings.ordersTabReturned},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesTab(OrderModel order) {
    switch (_selectedTab) {
      case _OrderTab.all:
        return true;
      case _OrderTab.ongoing:
        return [
          OrderStatus.placed,
          OrderStatus.confirmed,
          OrderStatus.preparing,
          OrderStatus.outForDelivery,
        ].contains(order.status);
      case _OrderTab.delivered:
        return order.status == OrderStatus.delivered;
      case _OrderTab.cancelled:
        return order.status == OrderStatus.cancelled;
      case _OrderTab.returned:
        return order.status == OrderStatus.returned;
    }
  }

  bool _matchesQuery(OrderModel order) {
    if (_query.isEmpty) return true;
    if (order.orderId.toLowerCase().contains(_query)) return true;
    return order.items.any(
      (item) => item.product.name.toLowerCase().contains(_query),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = context.watch<OrdersProvider>().orders;
    final filtered =
        allOrders.where((o) => _matchesTab(o) && _matchesQuery(o)).toList()
          ..sort(
            (a, b) => _newestFirst
                ? b.placedAt.compareTo(a.placedAt)
                : a.placedAt.compareTo(b.placedAt),
          );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 4),
            _buildTabs(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final order = filtered[index];
                        return OrderListCard(
                          order: order,
                          onViewDetails: () => _openTrackOrder(context, order),
                          onTrackOrder: () => _openTrackOrder(context, order),
                          onOrderAgain: () => _orderAgain(context, order),
                          onCancelOrder: () => _confirmCancel(context, order),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.myOrders,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppStrings.myOrdersSubtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showSortSheet(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: const [
                  Icon(Icons.filter_list, size: 18, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    AppStrings.filter,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _tabs.map((t) {
          final tab = t['tab'] as _OrderTab;
          final label = t['label'] as String;
          final selected = _selectedTab == tab;

          return Padding(
            padding: const EdgeInsets.only(right: 22),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: Column(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? AppColors.primary : AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2.4,
                    width: 26,
                    color: selected ? AppColors.primary : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: AppStrings.searchOrdersHint,
                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13.5),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySoft,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.noOrdersFoundTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              AppStrings.noOrdersFoundDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.sortBy,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // Only changed: RadioGroup is now the ancestor
                // that manages groupValue and onChanged.
                RadioGroup<bool>(
                  groupValue: _newestFirst,
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() => _newestFirst = v);
                    Navigator.pop(sheetContext);
                  },
                  child: Column(
                    children: [
                      RadioListTile<bool>(
                        value: true,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(AppStrings.newestFirst),
                      ),
                      RadioListTile<bool>(
                        value: false,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(AppStrings.oldestFirst),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openTrackOrder(BuildContext context, OrderModel order) {
    Navigator.of(context).push(
      AppRoutes.trackOrderRoute(
        orderId: order.orderId,
        placedAt: order.placedAt,
        items: order.items,
        address: order.address,
        deliveryOption: order.deliveryOption,
        paymentMethod: order.paymentMethod,
        platformFee: order.platformFee,
      ),
    );
  }

  void _orderAgain(BuildContext context, OrderModel order) {
    final cart = context.read<CartProvider>();

    for (final item in order.items) {
      cart.addItem(item.product, item.weightGrams, item.quantity);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${order.items.length} item(s) added to cart'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _confirmCancel(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.cancelOrderConfirmTitle),
        content: const Text(AppStrings.cancelOrderConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.no),
          ),
          TextButton(
            onPressed: () {
              context.read<OrdersProvider>().cancelOrder(order.orderId);

              Navigator.pop(dialogContext);
            },
            child: const Text(
              AppStrings.yesCancel,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
