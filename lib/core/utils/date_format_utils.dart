class DateFormatUtils {
  DateFormatUtils._();

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static String formatFullDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }
}