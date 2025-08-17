
class AuthValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value, {bool isOptional = false}) {
    if (value == null || value.isEmpty) {
      if (isOptional) {
        return null;
      }
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? validateYear(int? value) {
    if (value == null) {
      return 'Please select a study year';
    }
    return null;
  }

  static String? validateDepartment(int? value) {
    if (value == null) {
      return 'Please select a department';
    }
    return null;
  }
}