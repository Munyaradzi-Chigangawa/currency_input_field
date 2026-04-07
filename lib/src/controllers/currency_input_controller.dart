import 'package:currency_input_field/currency_input_field.dart';
import 'package:flutter/foundation.dart';

/// Controls the selected currency and amount for a [CurrencyInputField].
///
/// This controller is useful when you want to:
/// - read the current field state
/// - update currency or amount programmatically
/// - prefill values
/// - clear the field from outside the widget
///
/// The generic type [T] allows currency values to be represented as:
/// - `String` currency codes
/// - enums
/// - custom model objects
class CurrencyInputController<T> extends ValueNotifier<CurrencyInputValue<T>> {
  /// Creates a controller with optional initial currency and amount values.
  CurrencyInputController({
    T? initialCurrency,
    String initialAmount = '',
  }) : super(
          CurrencyInputValue<T>(
            currency: initialCurrency,
            amountText: initialAmount,
          ),
        );

  /// The currently selected currency value.
  T? get currency => value.currency;

  /// The current raw amount text.
  String get amountText => value.amountText;

  /// The parsed numeric amount, or `null` if the current text is empty
  /// or invalid.
  double? get amount => value.amount;

  /// Updates the selected currency.
  void setCurrency(T? currency) {
    value = value.copyWith(currency: currency);
  }

  /// Updates the raw amount text.
  void setAmountText(String amountText) {
    value = value.copyWith(amountText: amountText);
  }

  /// Clears both the selected currency and amount text.
  void clear() {
    value = CurrencyInputValue<T>();
  }
}
