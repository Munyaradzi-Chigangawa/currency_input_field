import 'package:currency_input_field/currency_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyInputField example app', () {
    Future<void> pumpHarness(
      WidgetTester tester, {
      CurrencyInputController<String>? controller,
      String? Function(String)? amountValidator,
      String? Function(CurrencyInputValue<String>)? validator,
      bool enabled = true,
      bool readOnlyAmount = false,
      bool requireCurrency = true,
      bool requireAmount = true,
      CurrencyInputLayoutMode layoutMode = CurrencyInputLayoutMode.inline,
      VoidCallback? onSubmitTap,
    }) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    CurrencyInputField<String>(
                      controller: controller,
                      currencies: const ['USD', 'GBP', 'ZWG'],
                      currencyLabelBuilder: (currency) => currency,
                      currencyHintText: 'Currency',
                      monetaryHintText: 'Amount',
                      enabled: enabled,
                      readOnlyAmount: readOnlyAmount,
                      requireCurrency: requireCurrency,
                      requireAmount: requireAmount,
                      layoutMode: layoutMode,
                      autovalidateMode: AutovalidateMode.disabled,
                      amountValidator: amountValidator,
                      validator: validator,
                      containerPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0,
                      ),
                      fieldHorizontalPadding: 10,
                      fieldVerticalPadding: 8,
                      inlineDividerHeight: 32,
                      stackedDividerSpacing: 1,
                      useLabelText: true,
                      style: const CurrencyInputFieldStyle(
                        currencyDecoration: InputDecoration(
                          labelText: 'Currency',
                          hintText: 'Select currency',
                        ),
                        amountDecoration: InputDecoration(
                          labelText: 'Amount',
                          hintText: 'Enter amount',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: onSubmitTap ??
                          () {
                            formKey.currentState!.validate();
                          },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
    }

    Finder findAmountField() {
      return find.byKey(const Key('currency_input_amount_field'));
    }

    Finder findCurrencyDropdown() {
      return find.byWidgetPredicate(
        (widget) =>
            widget is DropdownButtonFormField<String> &&
            widget.decoration.labelText == 'Currency',
      );
    }

    testWidgets('renders currency and amount inputs', (
      WidgetTester tester,
    ) async {
      await pumpHarness(tester);

      expect(findCurrencyDropdown(), findsOneWidget);
      expect(findAmountField(), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('shows invalid form when amount is empty', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  CurrencyInputField<String>(
                    currencies: const ['USD', 'GBP', 'ZWG'],
                    currencyLabelBuilder: (currency) => currency,
                    currencyHintText: 'Currency',
                    monetaryHintText: 'Amount',
                    autovalidateMode: AutovalidateMode.disabled,
                    amountValidator: (amountText) {
                      if (amountText.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      return null;
                    },
                    containerPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0,
                    ),
                    fieldHorizontalPadding: 10,
                    fieldVerticalPadding: 8,
                    inlineDividerHeight: 32,
                    stackedDividerSpacing: 1,
                    useLabelText: true,
                    style: const CurrencyInputFieldStyle(
                      currencyDecoration: InputDecoration(
                        labelText: 'Currency',
                      ),
                      amountDecoration: InputDecoration(labelText: 'Amount'),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(formKey.currentState!.validate(), isFalse);
    });

    testWidgets('accepts valid amount input', (WidgetTester tester) async {
      final controller = CurrencyInputController<String>(
        initialCurrency: 'USD',
        initialAmount: '',
      );

      await pumpHarness(
        tester,
        controller: controller,
        amountValidator: (amountText) {
          if (amountText.trim().isEmpty) {
            return 'Amount is required';
          }

          final parsed = double.tryParse(amountText);
          if (parsed == null) {
            return 'Invalid amount';
          }

          if (parsed <= 0) {
            return 'Amount must be greater than zero';
          }

          return null;
        },
      );

      await tester.enterText(findAmountField(), '25.50');
      await tester.pumpAndSettle();

      expect(find.text('25.50'), findsOneWidget);
      expect(controller.amountText, '25.50');
      expect(controller.amount, 25.50);
      expect(controller.currency, 'USD');

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Amount is required'), findsNothing);
      expect(find.text('Invalid amount'), findsNothing);
      expect(find.text('Amount must be greater than zero'), findsNothing);
    });

    testWidgets('supports cross-field validation', (WidgetTester tester) async {
      final controller = CurrencyInputController<String>(
        initialCurrency: 'USD',
        initialAmount: '',
      );

      await pumpHarness(
        tester,
        controller: controller,
        amountValidator: (amountText) {
          if (amountText.trim().isEmpty) {
            return 'Amount is required';
          }
          return null;
        },
        validator: (value) {
          final amount = value.amount;
          if (value.currency == 'USD' && amount != null && amount < 5) {
            return 'Minimum USD amount is 5';
          }
          return null;
        },
      );

      await tester.enterText(findAmountField(), '2');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Minimum USD amount is 5'), findsOneWidget);
    });

    testWidgets('readOnly amount field does not become editable', (
      WidgetTester tester,
    ) async {
      final controller = CurrencyInputController<String>(
        initialCurrency: 'USD',
        initialAmount: '49.99',
      );

      await pumpHarness(tester, controller: controller, readOnlyAmount: true);

      final textField = tester.widget<TextField>(findAmountField());
      expect(textField.readOnly, isTrue);
      expect(find.text('49.99'), findsOneWidget);
    });

    testWidgets('disabled field is rendered disabled', (
      WidgetTester tester,
    ) async {
      final controller = CurrencyInputController<String>(
        initialCurrency: 'USD',
        initialAmount: '0.00',
      );

      await pumpHarness(
        tester,
        controller: controller,
        enabled: false,
        requireCurrency: false,
        requireAmount: false,
      );

      final textField = tester.widget<TextField>(findAmountField());
      expect(textField.enabled, isFalse);
      expect(find.text('0.00'), findsOneWidget);
    });

    testWidgets('stacked layout still renders both controls', (
      WidgetTester tester,
    ) async {
      await pumpHarness(tester, layoutMode: CurrencyInputLayoutMode.stacked);

      expect(findCurrencyDropdown(), findsOneWidget);
      expect(findAmountField(), findsOneWidget);
      expect(
        find.byKey(const Key('currency_input_stacked_layout')),
        findsOneWidget,
      );
    });

    testWidgets('inline layout renders inline wrapper', (
      WidgetTester tester,
    ) async {
      await pumpHarness(tester, layoutMode: CurrencyInputLayoutMode.inline);

      expect(
        find.byKey(const Key('currency_input_inline_layout')),
        findsOneWidget,
      );
    });

    testWidgets('controller clear resets amount text', (
      WidgetTester tester,
    ) async {
      final controller = CurrencyInputController<String>(
        initialCurrency: 'USD',
        initialAmount: '12.34',
      );

      await pumpHarness(tester, controller: controller);

      expect(find.text('12.34'), findsOneWidget);

      controller.clear();
      await tester.pumpAndSettle();

      expect(controller.amountText, isEmpty);
    });
  });
}
