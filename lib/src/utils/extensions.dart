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
