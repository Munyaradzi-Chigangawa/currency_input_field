import 'package:flutter/services.dart';

/// Restricts text input to valid decimal numbers.
///
/// This formatter supports:
/// - configurable decimal precision
/// - optional negative values
/// - intermediate editing states such as a trailing decimal point
///
/// It is used internally by [CurrencyInputField], but it can also be reused
/// in other numeric text fields.
class DecimalTextInputFormatter extends TextInputFormatter {
  /// Creates a decimal input formatter.
  ///
  /// The [decimalRange] must be greater than or equal to zero.
  DecimalTextInputFormatter({
    this.decimalRange = 2,
    this.allowNegative = false,
  }) : assert(decimalRange >= 0);

  /// The maximum number of digits allowed after the decimal point.
  final int decimalRange;

  /// Whether negative values are allowed.
  final bool allowNegative;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final negativePart = allowNegative ? '-?' : '';
    final decimalPart = decimalRange > 0 ? '(\\.\\d{0,$decimalRange})?' : '';
    final regExp = RegExp('^$negativePart\\d*$decimalPart\$');

    final isStandaloneMinus = allowNegative && text == '-';
    final isTrailingDot =
        decimalRange > 0 && RegExp('^$negativePart\\d+\\.\$').hasMatch(text);
    final isLeadingDot = decimalRange > 0 &&
        RegExp('^$negativePart\\.\\d{0,$decimalRange}\$').hasMatch(text);

    if (regExp.hasMatch(text) ||
        isStandaloneMinus ||
        isTrailingDot ||
        isLeadingDot) {
      return newValue;
    }

    return oldValue;
  }
}
