import '../constants/strings.dart';

class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterName;
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterUsername;
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterEmail;
    }
    // This regex pattern provides a good balance between complexity and accuracy for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return Strings.pleaseEnterValidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterPassword;
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterAge;
    }
    final age = int.tryParse(value);
    if (age == null) {
      return Strings.pleaseEnterValidAge;
    }
    if (age < 13 || age > 120) {
      return 'Age must be between 13 and 120';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.pleaseEnterWeight;
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return Strings.pleaseEnterValidNumber;
    }
    if (weight <= 0 || weight > 500) {
      return 'Weight must be between 0 and 500 kg';
    }
    return null;
  }
}
