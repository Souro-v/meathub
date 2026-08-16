import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/coupon_utils.dart';
import 'package:meathub/core/widgets/checkout_item_row.dart';
import 'package:meathub/core/widgets/checkout_step_indicator.dart';
import 'package:meathub/core/widgets/coupon_section.dart';
import 'package:meathub/core/widgets/delivery_option_tile.dart';
import 'package:meathub/core/widgets/order_note_tile.dart';
import 'package:meathub/data/dummy_addresses.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/coupon_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/providers/coupon_provider.dart';
import 'package:meathub/screens/address/address_selection_screen.dart';
import 'package:meathub/screens/address/use_current_location_sheet.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> items;
  const CheckoutScreen({super.key, required this.items});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const double _platformFee = 20; // this screen's own value — see earlier conflict note

  String _selectedDeliveryId = 'standard';

  DeliveryOptionModel get _selectedOption =>
      DummyData.deliveryOptions.firstWhere((o) => o.id == _selectedDeliveryId);

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final defaultAddress = DummyAddresses.managed.firstWhere((a) => a.isDefault, orElse: () => DummyAddresses.managed.first);

    final subtotal = items.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final totalQuantity = items.fold<int>(0, (sum, item) => sum + item.quantity);

    final coupon = context.watch<CouponProvider>().appliedCoupon;
    double discount = 0;
    double deliveryFee = _selectedOption.fee;
    if (coupon != null) {
      final error = CouponUtils.validate(coupon, items, subtotal);
      if (error.isEmpty) {
        if (coupon.type == CouponType.freeDelivery) {
          deliveryFee = 0;
        } else {
          discount = CouponUtils.calculateDiscount(coupon, items, subtotal);
        }
      }
    }
    final total = subtotal - discount + deliveryFee + _platformFee;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CheckoutStepIndicator(currentStep: 0),
                    const SizedBox(height: 20),
                    const Text(AppStrings.deliverToLabel, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    _buildAddressCard(context, defaultAddress),
                    const SizedBox(height: 10),
                    _buildUseCurrentLocationButton(context),
                    const SizedBox(height: 22),
                    const Text(AppStrings.deliveryOptions, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    ...DummyData.deliveryOptions.map((o) => DeliveryOptionTile(
                      option: o,
                      selected: _selectedDeliveryId == o.id,
                      onTap: () => setState(() => _selectedDeliveryId = o.id),
                    )),
                    const SizedBox(height: 12),
                    const Text(AppStrings.orderSummary, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    ...items.map((item) => CheckoutItemRow(item: item)),
                    CouponSection(items: items, subtotal: subtotal, originalDeliveryFee: _selectedOption.fee),
                    OrderNoteTile(title: AppStrings.addOrderNoteOptional, placeholder: AppStrings.orderNoteExample),
                    const SizedBox(height: 22),
                    const Text(AppStrings.priceDetails, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    _priceRow('${AppStrings.subtotal} ($totalQuantity ${AppStrings.itemsLabel})', '৳${subtotal.toStringAsFixed(0)}'),
                    if (discount > 0) ...[
                      const SizedBox(height: 8),
                      _priceRow(AppStrings.couponDiscountLabel, '- ৳${discount.toStringAsFixed(0)}', valueColor: AppColors.success),
                    ],
                    const SizedBox(height: 8),
                    _priceRow(AppStrings.deliveryFee, deliveryFee == 0 ? AppStrings.freeLabel : '৳${deliveryFee.toStringAsFixed(0)}',
                        valueColor: deliveryFee == 0 ? AppColors.success : AppColors.textDark),
                    const SizedBox(height: 8),
                    _priceRow(AppStrings.platformFee, '৳${_platformFee.toStringAsFixed(0)}'),
                    const SizedBox(height: 10),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(AppStrings.totalAmount, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                        Text('৳${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                            child: const Icon(Icons.check, size: 13, color: AppColors.white),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.safeSecureTitle, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                                Text(AppStrings.safeSecureDesc, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(total),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, size: 22, color: AppColors.textDark)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(AppStrings.checkout, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text(AppStrings.checkoutSubtitle, style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined, size: 15, color: AppColors.primary),
                SizedBox(width: 4),
                Text(AppStrings.secureCheckout, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, dynamic address) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
            child: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.label, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.primary)),
                      child: const Text(AppStrings.currentBadge, style: TextStyle(fontSize: 10.5, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(address.address, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4)),
                const SizedBox(height: 4),
                Text(address.phone, style: const TextStyle(fontSize: 12.5, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddressSelectionScreen())),
            child: Row(
              children: const [
                Text(AppStrings.change, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseCurrentLocationButton(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const UseCurrentLocationSheet(),
      ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: const [
            Icon(Icons.my_location, size: 17, color: AppColors.primary),
            SizedBox(width: 10),
            Expanded(
              child: Text(AppStrings.deliverToCurrentLocation, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ),
            Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {Color valueColor = AppColors.textDark}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor)),
      ],
    );
  }

  Widget _buildBottomBar(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.divider))),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.totalAmount, style: TextStyle(fontSize: 11.5, color: AppColors.textHint)),
              Text('৳${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surface),
            child: const Icon(Icons.keyboard_arrow_up, size: 18, color: AppColors.textDark),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                AppRoutes.paymentRoute(
                  items: widget.items,
                  deliveryOption: _selectedOption,
                  address: DummyAddresses.managed.firstWhere((a) => a.isDefault, orElse: () => DummyAddresses.managed.first),
                  platformFee: _platformFee,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(AppStrings.continueToPayment),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}