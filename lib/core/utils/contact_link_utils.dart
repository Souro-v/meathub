import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class ContactLinkUtils {
  ContactLinkUtils._();

  static Future<void> _open(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.couldNotOpenLink),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.couldNotOpenLink),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  static Future<void> openWhatsApp(BuildContext context, String phone) {
    return _open(context, Uri.parse('https://wa.me/$phone'));
  }

  static Future<void> sendEmail(BuildContext context, String email) {
    return _open(
      context,
      Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=MeatHub Support Request',
      ),
    );
  }

  static Future<void> callPhone(BuildContext context, String phone) {
    return _open(context, Uri(scheme: 'tel', path: phone));
  }
}
