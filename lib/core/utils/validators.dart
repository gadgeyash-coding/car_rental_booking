class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter valid email (abc@gmail.com)';
    return null;
  }
  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Password must be 6+ chars';
    return null;
  }
}