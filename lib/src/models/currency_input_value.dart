import 'package:flutter/foundation.dart';

/// Represents the current combined value of a [CurrencyInputField].
///
/// This value object contains:
/// - the selected currency
/// - the raw amount text entered by the user
/// - a parsed numeric amount available through [amount]
@immutable
class CurrencyInputValue<T> {
  /// Creates a currency input value.
  const CurrencyInputValue({
    this.currency,
    this.amountText = '',
  });

  /// The currently selected currency.
  final T? currency;

  /// The raw amount text as entered by the user.
  final String amountText;

  /// The parsed numeric amount.
  ///
  /// Returns `null` when the amount text is empty or cannot be parsed.
  double? get amount {
    final normalized = amountText.trim().replaceAll(',', '');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  /// Whether a currency has been selected.
  bool get hasCurrency => currency != null;

  /// Whether the amount field contains non-empty text.
  bool get hasAmount => amountText.trim().isNotEmpty;

  /// Returns a copy of this value with updated fields.
  ///
  /// Use [clearCurrency] to force the currency to `null`, and [clearAmount]
  /// to reset the amount text to an empty string.
  CurrencyInputValue<T> copyWith({
    T? currency,
    String? amountText,
    bool clearCurrency = false,
    bool clearAmount = false,
  }) {
    return CurrencyInputValue<T>(
      currency: clearCurrency ? null : (currency ?? this.currency),
      amountText: clearAmount ? '' : (amountText ?? this.amountText),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CurrencyInputValue<T> &&
            currency == other.currency &&
            amountText == other.amountText;
  }

  @override
  int get hashCode => Object.hash(currency, amountText);

  @override
  String toString() {
    return 'CurrencyInputValue<$T>(currency: $currency, amountText: $amountText)';
  }
}
