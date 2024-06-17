import 'package:flutter/services.dart';

class DigitOnlyFormatter extends TextInputFormatter {
  static const int maxLength = 16;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // Remove any non-digit characters
    final String digitsOnly = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // Ensure the length does not exceed the maxLength
    if (digitsOnly.length > maxLength) {
      return oldValue;
    }

    return newValue.copyWith(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}

class AmountOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // Remove any non-digit characters
    final String digitsOnly = newText.replaceAll(RegExp(r'[^0-9,^.]'), '');

    return newValue.copyWith(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}
