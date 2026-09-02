import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/order_submission_utils.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/payment_method_model.dart';

class PaymentFailedScreen extends StatelessWidget {
  final List<CartItemModel> items;
  final DeliveryOptionModel deliveryOption;
  final ManagedAddressModel address;
  final double platformFee;
  final PaymentMethodModel paymentMethod;

  const PaymentFailedScreen({
    super.key,
    required this.items,
    required this.deliveryOption,
    required this.address,
    required this.platformFee,
    required this.paymentMethod,
  });

  void _tryAgain(BuildContext context) {
    final success = OrderSubmissionUtils.attemptPayment(paymentMethod);
    if (success) {
      OrderSubmissionUtils.submitOrderAndNavigate(
        context,
        items: items,
        address: address,
        deliveryOption: deliveryOption,
        paymentMethod: paymentMethod,
        platformFee: platformFee,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.paymentFailedAgainMessage), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primarySoft),
                      child: const Icon(Icons.sentiment_dissatisfied_outlined, size: 56, color: AppColors.primary),
                    ),
                    const SizedBox(height: 22),
                    const Text(AppStrings.paymentFailedTitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    const Text(AppStrings.paymentFailedDesc, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.5)),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: const [
                          Icon(Icons.shield_outlined, size: 18, color: AppColors.success),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              AppStrings.paymentNotCompletedNote,
                              style: TextStyle(fontSize: 12.5, color: AppColors.success, fontWeight: FontWeight.w600, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _tryAgain(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size(0, 54),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(AppStrings.tryAgain),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        AppRoutes.paymentRoute(items: items, deliveryOption: deliveryOption, address: address, platformFee: platformFee),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        minimumSize: const Size(0, 54),
                        textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(AppStrings.chooseAnotherPaymentMethod),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false, arguments: 2),
                    child: const Text(AppStrings.backToOrder, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, size: 22, color: AppColors.textDark)),
          ),
        ],
      ),
    );
  }
}