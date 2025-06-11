class DateFormatHelper {
  // Format date for display (DD/MM/YYYY)
  static String formatDateForDisplay(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Format date for API (YYYY-MM-DDT00:00:00.000Z)
  static String formatDateForApi(DateTime date) {
    return date.toUtc().toIso8601String();
  }

  // Parse display format (DD/MM/YYYY) to DateTime
  static DateTime? parseDisplayDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length != 3) return null;
      return DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
    } catch (e) {
      return null;
    }
  }
}
