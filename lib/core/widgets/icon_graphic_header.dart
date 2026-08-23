import 'package:flutter/material.dart';

class IconGraphicHeader extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final String title;

  const IconGraphicHeader({
    super.key,
    required this.icon,
    required this.color,
    required this.bg,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(icon, size: 48, color: color),
        ),
        const SizedBox(height: 14),
        Text(title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}