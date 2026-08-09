import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep; // 0 = Address, 1 = Payment, 2 = Place Order

  const CheckoutStepIndicator({super.key, required this.currentStep});

  static const List<String> _labels = [AppStrings.stepAddress, AppStrings.stepPayment, AppStrings.stepPlaceOrder];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final leftStepDone = (i ~/ 2) < currentStep;
            return Expanded(
              child: Container(height: 1.4, color: leftStepDone ? AppColors.primary : AppColors.divider),
            );
          }
          final step = i ~/ 2;
          final isActive = step == currentStep;
          final isDone = step < currentStep;
          return Column(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive || isDone ? AppColors.primary : AppColors.white,
                  border: Border.all(color: isActive || isDone ? AppColors.primary : AppColors.divider),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 15, color: AppColors.white)
                    : Text('${step + 1}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isActive ? AppColors.white : AppColors.textHint)),
              ),
              const SizedBox(height: 6),
              Text(_labels[step],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.primary : AppColors.textHint,
                  )),
            ],
          );
        }),
      ),
    );
  }
}