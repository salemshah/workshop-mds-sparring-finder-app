extension StringCasingExtension on String {
  String capitalizeEachWord() {
    return split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }
}

extension LimitLength on String {
  String limit(int maxLength) {
    if (length <= maxLength) return this;
    return substring(0, maxLength);
  }
}

extension DateTimeExtensions on DateTime {
  /// Returns time in "HH:MM AM/PM" format, e.g. "09:30 AM"
  String get time {
    final hour = this.hour % 12 == 0 ? 12 : this.hour % 12;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Returns date in "Month Day, Year" format, e.g. "May 25, 2025"
  String get date {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final month = months[this.month - 1];
    return '$month $day, $year';
  }

  /// Full readable format: "May 25, 2025 – 09:30 AM"
  String get readable {
    return '$date – $time';
  }
}
