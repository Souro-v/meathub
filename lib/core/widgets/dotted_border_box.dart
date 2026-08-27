import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

class DottedBorderBox extends StatelessWidget {
  final Widget child;
  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBoxPainter(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 26),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _DashedBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(14));
    final path = Path()..addRRect(rrect);
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final dest = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dest.addPath(metric.extractPath(distance, distance + dashWidth), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dest, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}