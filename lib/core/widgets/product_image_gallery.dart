import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final bool isFreshToday;
  final int discountPercent;

  const ProductImageGallery({
    super.key,
    required this.images,
    this.isFreshToday = false,
    this.discountPercent = 0,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.4,
                child: Image.asset(
                  widget.images[_selected],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              if (widget.isFreshToday)
                Positioned(
                  top: 12,
                  left: 12,
                  child: _Badge(
                    icon: Icons.eco,
                    label: AppStrings.freshToday,
                    bg: const Color(0xFFE1F5E4),
                    fg: const Color(0xFF2E7D32),
                  ),
                ),
              if (widget.discountPercent > 0)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _Badge(
                    label: '${widget.discountPercent}% OFF',
                    bg: AppColors.primary,
                    fg: AppColors.white,
                  ),
                ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    size: 20,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final isSelected = index == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = index),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.divider,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        widget.images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color bg;
  final Color fg;

  const _Badge({
    this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
