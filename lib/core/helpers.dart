class Helpers {
  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static bool isNullOrEmpty(String? s) => s == null || s.trim().isEmpty;
}
