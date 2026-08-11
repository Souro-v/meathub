import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/delivery_rider_model.dart';

class DeliveryPartnerSection extends StatelessWidget {
  final DeliveryRiderModel rider;
  final String estimatedWindow;

  const DeliveryPartnerSection({super.key, required this.rider, required this.estimatedWindow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.deliveryPartner, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.surface,
                  child: Icon(Icons.person, size: 26, color: AppColors.textHint),
                ),
                const SizedBox(height: 8),
                Text(rider.name, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.star, size: 13, color: Color(0xFFFFA726)),
                    const SizedBox(width: 3),
                    Text('${rider.rating} (${rider.orderCount} ${AppStrings.ordersCountSuffix})', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.call_outlined, size: 16, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.estimatedDelivery, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 6),
                Text(estimatedWindow, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 10),
                _buildRouteMap(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 110,
        width: double.infinity,
        child: Stack(
          children: [
            Container(color: const Color(0xFFE9E9EA)),
            CustomPaint(painter: _RoutePainter(), size: Size.infinite),
            const Positioned(bottom: 8, left: 8, child: Icon(Icons.two_wheeler, color: AppColors.primary, size: 20)),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                child: const Icon(Icons.home, color: AppColors.white, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.9, size.width * 0.55, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.1, size.width * 0.88, size.height * 0.15);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}