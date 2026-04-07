import 'package:flutter/foundation.dart';

@immutable
class CurrencyInputValue<T> {
  const CurrencyInputValue({
    this.currency,
    this.amountText = '',
  });

  final T? currency;
  final String amountText;

  double? get amount {
    final normalized = amountText.trim().replaceAll(',', '');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  bool get hasCurrency => currency != null;
  bool get hasAmount => amountText.trim().isNotEmpty;

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