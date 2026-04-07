import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    this.decimalRange = 2,
    this.allowNegative = false,
  }) : assert(decimalRange >= 0);

  final int decimalRange;
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
