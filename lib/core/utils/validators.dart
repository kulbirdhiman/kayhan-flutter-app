class Validators {
  Validators._();

  static String? required(String? v, [String field = 'This field']) =>
      (v == null || v.trim().isEmpty) ? '$field is required' : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Use at least 8 characters';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length < 8 ? 'Enter a valid phone number' : null;
  }

  static String? postcode(String? v) {
    if (v == null || v.trim().isEmpty) return 'Postcode is required';
    return RegExp(r'^\d{4}$').hasMatch(v.trim()) ? null : 'Enter a 4-digit postcode';
  }
}
