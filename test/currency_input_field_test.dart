import 'package:currency_input_field/currency_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Currency dropdown works correctly', (WidgetTester tester) async {
    String selectedCurrency = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CurrencyInputField(
            currencies: ['USD', 'EUR', 'GBP'],
            onCurrencyChanged: (currency) {
              selectedCurrency = currency;
            },
            onAmountChanged: (amount) {},
            currencyHintText: 'Currency',
            monetaryHintText: 'Amount',
          ),
        ),
      ),
    );

    // Open the dropdown
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Select 'USD'
    await tester.tap(find.text('USD').last);
    await tester.pumpAndSettle();

    // Verify that the selected currency is 'USD'
    expect(selectedCurrency, 'USD');
  });
}
