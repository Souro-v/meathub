import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

/// Drop-in replacement for `Image.asset(product.image, ...)`.
/// If the source is a Cloudinary/network URL, loads + caches it over the
/// network (this is what shrinks the app's install size — images are no
/// longer bundled). If it's still a local asset path, falls back to
/// Image.asset — so migration can happen product-by-product without
/// breaking anything mid-way.
class SmartProductImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final int? cacheWidth;

  const SmartProductImage(this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheWidth,
  });

  bool get _isNetwork =>
      source.startsWith('http://') || source.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: source,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth,
        placeholder: (context, url) =>
            Container(
              width: width,
              height: height,
              color: AppColors.surface,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary)),
                ),
              ),
            ),
        errorWidget: (context, url, error) =>
            Container(
              width: width,
              height: height,
              color: AppColors.surface,
              child: const Icon(
                  Icons.image_not_supported_outlined, color: AppColors.textHint,
                  size: 28),
            ),
      );
    }
    return Image.asset(
        source, width: width, height: height, fit: fit, cacheWidth: cacheWidth);
  }
}