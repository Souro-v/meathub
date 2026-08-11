import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/tracking_step_model.dart';

class OrderUtils {
  OrderUtils._();

  static String generateOrderId() {
    final rand = Random();
    final number = 100000 + rand.nextInt(899999);
    return '#MH$number';
  }

  static int calculatePoints(double total) {
    return (total / 100).floor().clamp(1, 999);
  }

  static String estimatedDeliveryWindow(String durationSubtitle) {
    final match = RegExp(r'(\d+)\s*-\s*(\d+)').firstMatch(durationSubtitle);
    final minMinutes = match != null ? int.parse(match.group(1)!) : 30;
    final maxMinutes = match != null ? int.parse(match.group(2)!) : 60;

    final now = DateTime.now();
    final start = now.add(Duration(minutes: minMinutes));
    final end = now.add(Duration(minutes: maxMinutes));

    return 'Today, ${formatTime(start)} - ${formatTime(end)}';
  }

  static String formatTime(DateTime time) {
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour12:$minute $period';
  }

  static Map<String, DateTime> deliveryWindow(DateTime placedAt) {
    return {
      'start': placedAt.add(const Duration(minutes: 135)),
      'end': placedAt.add(const Duration(minutes: 195)),
    };
  }

  static String deliveryWindowLabel(DateTime placedAt) {
    final window = deliveryWindow(placedAt);
    return '${formatTime(window['start']!)} - ${formatTime(window['end']!)}';
  }

  /// Demo tracking timeline relative to [placedAt]. No live backend —
  /// "Out for Delivery" is always the current/live stage, matching the design.
  static List<TrackingStepModel> buildTrackingSteps(DateTime placedAt) {
    final confirmedAt = placedAt.add(const Duration(minutes: 2));
    final preparingAt = placedAt.add(const Duration(minutes: 15));
    final outForDeliveryAt = placedAt.add(const Duration(minutes: 90));

    return [
      TrackingStepModel(
        title: AppStrings.stepOrderPlaced,
        icon: Icons.check,
        timeLabel: 'Today, ${formatTime(placedAt)}',
        status: TrackingStepStatus.completed,
      ),
      TrackingStepModel(
        title: AppStrings.stepOrderConfirmed,
        icon: Icons.check,
        timeLabel: 'Today, ${formatTime(confirmedAt)}',
        status: TrackingStepStatus.completed,
      ),
      TrackingStepModel(
        title: AppStrings.stepPreparingOrder,
        icon: Icons.check,
        timeLabel: 'Today, ${formatTime(preparingAt)}',
        status: TrackingStepStatus.completed,
      ),
      TrackingStepModel(
        title: AppStrings.stepOutForDelivery,
        description: AppStrings.stepOutForDeliveryDesc,
        icon: Icons.two_wheeler,
        timeLabel: 'Today, ${formatTime(outForDeliveryAt)}',
        status: TrackingStepStatus.live,
      ),
      TrackingStepModel(
        title: AppStrings.stepDelivered,
        icon: Icons.shopping_bag_outlined,
        timeLabel: 'Expected Today, ${deliveryWindowLabel(placedAt)}',
        status: TrackingStepStatus.pending,
      ),
      TrackingStepModel(
        title: AppStrings.stepOrderCompleted,
        description: AppStrings.stepOrderCompletedDesc,
        icon: Icons.check,
        timeLabel: '',
        status: TrackingStepStatus.pending,
      ),
    ];
  }
}
