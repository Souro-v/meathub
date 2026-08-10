import 'dart:math';

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

    return 'Today, ${_formatTime(start)} - ${_formatTime(end)}';
  }

  static String _formatTime(DateTime time) {
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour12:$minute $period';
  }
}