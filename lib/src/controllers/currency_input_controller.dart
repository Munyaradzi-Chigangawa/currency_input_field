import 'package:currency_input_field/currency_input_field.dart';
import 'package:flutter/foundation.dart';

class CurrencyInputController<T> extends ValueNotifier<CurrencyInputValue<T>> {
  CurrencyInputController({
    T? initialCurrency,
    String initialAmount = '',
  }) : super(
          CurrencyInputValue<T>(
            currency: initialCurrency,
            amountText: initialAmount,
          ),
        );

  T? get currency => value.currency;
  String get amountText => value.amountText;
  double? get amount => value.amount;

  void setCurrency(T? currency) {
    value = value.copyWith(currency: currency);
  }

  void setAmountText(String amountText) {
    value = value.copyWith(amountText: amountText);
  }

  void clear() {
    value = CurrencyInputValue<T>();
  }
}
