class FormValidators {
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Additional phone number validation logic can be added here
    return null;
  }

  static String? validateExpiryDate(String? input) {
    final RegExp regExp = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$');

    if (input == null) {
      return 'Please enter valid expiry date';
    }

    if (!regExp.hasMatch(input)) {
      return 'Please enter valid expiry date';
    }

    final int month = int.parse(input.substring(0, 2));
    final int year = int.parse(input.substring(3, 5));

    final DateTime now = DateTime.now();
    final int currentYear = int.parse(now.year.toString().substring(2));
    final int currentMonth = now.month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Please enter valid expiry date';
    }

    return null;
  }
}
