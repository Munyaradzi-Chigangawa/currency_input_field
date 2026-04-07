import 'package:currency_input_field/src/formatters/decimal_text_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DecimalTextInputFormatter', () {
    test('allows valid decimal input within range', () {
      final formatter = DecimalTextInputFormatter(decimalRange: 2);

      const oldValue = TextEditingValue(text: '12.3');
      const newValue = TextEditingValue(text: '12.34');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '12.34');
    });

    test('rejects input exceeding decimal range', () {
      final formatter = DecimalTextInputFormatter(decimalRange: 2);

      const oldValue = TextEditingValue(text: '12.34');
      const newValue = TextEditingValue(text: '12.345');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '12.34');
    });

    test('allows empty text', () {
      final formatter = DecimalTextInputFormatter(decimalRange: 2);

      const oldValue = TextEditingValue(text: '12.34');
      const newValue = TextEditingValue(text: '');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '');
    });
  });
}
