import 'package:currency_input_field/src/currency_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_input_field/currency_input_field.dart';


void main() {
  testWidgets('Currency and amount input displays correctly', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CurrencyInputField(
            currencies: ['USD', 'EUR', 'GBP'],
            onCurrencyChanged: (currency) {},
            onAmountChanged: (amount) {},
            monetaryHintText: 'Amount',
            currencyHintText: 'Currency',
          ),
        ),
      ),
    );

    // Verify that our input widgets are displayed correctly.
    expect(find.text('Currency'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
  });

  testWidgets('Currency dropdown works correctly', (WidgetTester tester) async {
    String selectedCurrency = '';

    // Create the widget by telling the tester to build it.
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

    // Tap the dropdown button to open the menu.
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Tap the first item in the dropdown.
    await tester.tap(find.text('USD').last);
    await tester.pumpAndSettle();

    // Verify the selected currency.
    expect(selectedCurrency, 'USD');
  });

  testWidgets('Amount input validation works correctly', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CurrencyInputField(
            currencies: ['USD', 'EUR', 'GBP'],
            onCurrencyChanged: (currency) {},
            onAmountChanged: (amount) {},
            validateAmount: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
            currencyHintText: 'Currency',
            monetaryHintText: 'Amount',
          ),
        ),
      ),
    );


    // Leave the amount field empty and tap submit.
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Verify that the validation message is displayed.
    expect(find.text('Please enter an amount'), findsOneWidget);

    // Enter an invalid amount and tap submit.
    await tester.enterText(find.byType(TextFormField), '-5');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Verify that the validation message is displayed.
    expect(find.text('Please enter a valid amount'), findsOneWidget);

    // Enter a valid amount and tap submit.
    await tester.enterText(find.byType(TextFormField), '100');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Verify that no validation message is displayed.
    expect(find.text('Please enter a valid amount'), findsNothing);
  });

  testWidgets('CurrencyInputField displays correctly and validates input', (WidgetTester tester) async {
    String selectedCurrency = 'USD';
    double enteredAmount = 0.0;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CurrencyInputField(
          currencies: ['USD', 'EUR', 'GBP'],
          onCurrencyChanged: (value) {
            selectedCurrency = value;
          },
          onAmountChanged: (value) {
            enteredAmount = value;
          },
          currencyHintText: 'Select Currency',
          monetaryHintText: 'Enter Amount',
          validateAmount: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ),
    ));

    expect(find.text('Select Currency'), findsOneWidget);
    expect(find.text('Enter Amount'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '123.45');
    expect(enteredAmount, 123.45);

    await tester.enterText(find.byType(TextFormField), 'abc');
    await tester.tap(find.text('Enter Amount'));
    await tester.pump();

    expect(find.text('Please enter a valid number'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '');
    await tester.tap(find.text('Enter Amount'));
    await tester.pump();

    expect(find.text('Please enter an amount'), findsOneWidget);
  });
}

