import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponCodeChip extends StatelessWidget {
  final String code;
  final Color color;
  const CouponCodeChip({super.key, required this.code, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Code "$code" copied'), duration: const Duration(seconds: 1)),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: CustomPaint(
        painter: _DashedRectPainter(color: color),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(code, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.5)),
              const SizedBox(width: 5),
              Icon(Icons.copy, size: 12, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  _DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(8));
    final path = Path()..addRRect(rrect);
    const dashWidth = 4.0;
    const dashSpace = 3.0;
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