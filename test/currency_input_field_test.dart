import 'package:currency_input_field/currency_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithMaterial(Widget child, {Size? size}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size ?? const Size(500, 800)),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  CurrencyInputField<String> buildStringField({
    CurrencyInputController<String>? controller,
    List<String> currencies = const ['USD', 'GBP', 'ZAR'],
    ValueChanged<double>? onAmountChanged,
    ValueChanged<String?>? onCurrencyChanged,
    ValueChanged<CurrencyInputValue<String>>? onChanged,
    String? Function(String amountText)? amountValidator,
    String? Function(String? currency)? currencyValidator,
    String? Function(CurrencyInputValue<String> value)? validator,
    CurrencyInputLayoutMode layoutMode = CurrencyInputLayoutMode.adaptive,
    double stackBreakpoint = 360,
    bool requireCurrency = true,
    bool requireAmount = true,
  }) {
    return CurrencyInputField<String>(
      controller: controller,
      currencies: currencies,
      currencyLabelBuilder: (currency) => currency,
      currencyHintText: 'Currency',
      monetaryHintText: 'Amount',
      containerPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      fieldHorizontalPadding: 10,
      fieldVerticalPadding: 8,
      inlineDividerHeight: 32,
      stackedDividerSpacing: 1,
      useLabelText: false,
      onAmountChanged: onAmountChanged,
      onCurrencyChanged: onCurrencyChanged,
      onChanged: onChanged,
      amountValidator: amountValidator,
      currencyValidator: currencyValidator,
      validator: validator,
      layoutMode: layoutMode,
      stackBreakpoint: stackBreakpoint,
      requireCurrency: requireCurrency,
      requireAmount: requireAmount,
    );
  }

  CurrencyInputField<CurrencyCode> buildEnumField({
    CurrencyInputController<CurrencyCode>? controller,
    List<CurrencyCode> currencies = CurrencyCode.values,
    ValueChanged<double>? onAmountChanged,
    ValueChanged<CurrencyCode?>? onCurrencyChanged,
    ValueChanged<CurrencyInputValue<CurrencyCode>>? onChanged,
    String? Function(String amountText)? amountValidator,
    String? Function(CurrencyCode? currency)? currencyValidator,
    String? Function(CurrencyInputValue<CurrencyCode> value)? validator,
    CurrencyInputLayoutMode layoutMode = CurrencyInputLayoutMode.adaptive,
    double stackBreakpoint = 360,
    bool requireCurrency = true,
    bool requireAmount = true,
  }) {
    return CurrencyInputField<CurrencyCode>(
      controller: controller,
      currencies: currencies,
      currencyLabelBuilder: (currency) => currency.code,
      currencyHintText: 'Currency',
      monetaryHintText: 'Amount',
      containerPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      fieldHorizontalPadding: 10,
      fieldVerticalPadding: 8,
      inlineDividerHeight: 32,
      stackedDividerSpacing: 1,
      useLabelText: false,
      onAmountChanged: onAmountChanged,
      onCurrencyChanged: onCurrencyChanged,
      onChanged: onChanged,
      amountValidator: amountValidator,
      currencyValidator: currencyValidator,
      validator: validator,
      layoutMode: layoutMode,
      stackBreakpoint: stackBreakpoint,
      requireCurrency: requireCurrency,
      requireAmount: requireAmount,
    );
  }

  group('CurrencyInputField<String>', () {
    testWidgets('renders initial values from controller', (tester) async {
      final controller = CurrencyInputController<String>(
        initialCurrency: 'USD',
        initialAmount: '25.50',
      );

      await tester.pumpWidget(
        wrapWithMaterial(buildStringField(controller: controller)),
      );

      expect(find.text('25.50'), findsOneWidget);
      expect(controller.currency, 'USD');
      expect(controller.amountText, '25.50');
      expect(controller.amount, 25.50);
    });

    testWidgets('fires amount change callback', (tester) async {
      double? latestAmount;

      await tester.pumpWidget(
        wrapWithMaterial(
          buildStringField(
            currencies: const ['USD', 'GBP'],
            onAmountChanged: (amount) => latestAmount = amount,
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('currency_input_amount_field')),
        '123.45',
      );
      await tester.pump();

      expect(latestAmount, 123.45);
    });

    testWidgets('fires onChanged callback with combined value', (tester) async {
      CurrencyInputValue<String>? latestValue;

      await tester.pumpWidget(
        wrapWithMaterial(
          buildStringField(
            controller: CurrencyInputController<String>(
              initialCurrency: 'USD',
            ),
            onChanged: (value) => latestValue = value,
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('currency_input_amount_field')),
        '88.10',
      );
      await tester.pump();

      expect(latestValue, isNotNull);
      expect(latestValue!.currency, 'USD');
      expect(latestValue!.amountText, '88.10');
      expect(latestValue!.amount, 88.10);
    });

    testWidgets('fires string currency change callback', (tester) async {
      String? latestCurrency;

      await tester.pumpWidget(
        wrapWithMaterial(
          buildStringField(
            currencies: const ['USD', 'GBP'],
            onCurrencyChanged: (currency) => latestCurrency = currency,
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('GBP').last);
      await tester.pumpAndSettle();

      expect(latestCurrency, 'GBP');
    });

    testWidgets('uses stacked layout on narrow width in adaptive mode',
            (tester) async {
          await tester.pumpWidget(
            wrapWithMaterial(
              buildStringField(
                currencies: const ['USD', 'GBP'],
                layoutMode: CurrencyInputLayoutMode.adaptive,
                stackBreakpoint: 360,
              ),
              size: const Size(320, 700),
            ),
          );

          expect(
            find.byKey(const Key('currency_input_stacked_layout')),
            findsOneWidget,
          );
          expect(
            find.byKey(const Key('currency_input_inline_layout')),
            findsNothing,
          );
        });

    testWidgets('uses inline layout on wide width in adaptive mode',
            (tester) async {
          await tester.pumpWidget(
            wrapWithMaterial(
              buildStringField(
                currencies: const ['USD', 'GBP'],
                layoutMode: CurrencyInputLayoutMode.adaptive,
                stackBreakpoint: 360,
              ),
              size: const Size(500, 700),
            ),
          );

          expect(
            find.byKey(const Key('currency_input_inline_layout')),
            findsOneWidget,
          );
          expect(
            find.byKey(const Key('currency_input_stacked_layout')),
            findsNothing,
          );
        });

    testWidgets('uses stacked layout when explicitly requested',
            (tester) async {
          await tester.pumpWidget(
            wrapWithMaterial(
              buildStringField(
                layoutMode: CurrencyInputLayoutMode.stacked,
              ),
            ),
          );

          expect(
            find.byKey(const Key('currency_input_stacked_layout')),
            findsOneWidget,
          );
        });

    testWidgets('uses inline layout when explicitly requested',
            (tester) async {
          await tester.pumpWidget(
            wrapWithMaterial(
              buildStringField(
                layoutMode: CurrencyInputLayoutMode.inline,
              ),
            ),
          );

          expect(
            find.byKey(const Key('currency_input_inline_layout')),
            findsOneWidget,
          );
        });

    testWidgets('shows validation error when currency is missing',
            (tester) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            wrapWithMaterial(
              Form(
                key: formKey,
                child: buildStringField(
                  currencies: const ['USD', 'GBP'],
                ),
              ),
            ),
          );

          final valid = formKey.currentState?.validate() ?? false;
          await tester.pump();

          expect(valid, isFalse);
          expect(find.text('Please select a currency'), findsOneWidget);
        });

    testWidgets('shows validation error when amount is required but empty',
            (tester) async {
          final formKey = GlobalKey<FormState>();
          final controller = CurrencyInputController<String>(
            initialCurrency: 'USD',
            initialAmount: '',
          );

          await tester.pumpWidget(
            wrapWithMaterial(
              Form(
                key: formKey,
                child: buildStringField(
                  controller: controller,
                  requireCurrency: true,
                  requireAmount: true,
                ),
              ),
            ),
          );

          final valid = formKey.currentState?.validate() ?? false;
          await tester.pump();

          expect(valid, isFalse);
          expect(find.text('Please enter an amount'), findsOneWidget);
        });

    testWidgets('validates amount using custom validator', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = CurrencyInputController<String>(
        initialCurrency: 'USD',
        initialAmount: '0',
      );

      await tester.pumpWidget(
        wrapWithMaterial(
          Form(
            key: formKey,
            child: buildStringField(
              controller: controller,
              currencies: const ['USD', 'GBP'],
              amountValidator: (value) {
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Amount must be greater than 0';
                }
                return null;
              },
            ),
          ),
        ),
      );

      final valid = formKey.currentState?.validate() ?? false;
      await tester.pump();

      expect(valid, isFalse);
      expect(find.text('Amount must be greater than 0'), findsOneWidget);
    });

    testWidgets('validates currency using custom validator', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = CurrencyInputController<String>(
        initialCurrency: 'GBP',
        initialAmount: '10',
      );

      await tester.pumpWidget(
        wrapWithMaterial(
          Form(
            key: formKey,
            child: buildStringField(
              controller: controller,
              currencyValidator: (currency) {
                if (currency == 'GBP') {
                  return 'GBP is not allowed';
                }
                return null;
              },
            ),
          ),
        ),
      );

      final valid = formKey.currentState?.validate() ?? false;
      await tester.pump();

      expect(valid, isFalse);
      expect(find.text('GBP is not allowed'), findsOneWidget);
    });

    testWidgets('validates combined value using top-level validator',
            (tester) async {
          final formKey = GlobalKey<FormState>();
          final controller = CurrencyInputController<String>(
            initialCurrency: 'USD',
            initialAmount: '1000',
          );

          await tester.pumpWidget(
            wrapWithMaterial(
              Form(
                key: formKey,
                child: buildStringField(
                  controller: controller,
                  validator: (value) {
                    if (value.currency == 'USD' && (value.amount ?? 0) > 500) {
                      return 'USD amount cannot exceed 500';
                    }
                    return null;
                  },
                ),
              ),
            ),
          );

          final valid = formKey.currentState?.validate() ?? false;
          await tester.pump();

          expect(valid, isFalse);
          expect(find.text('USD amount cannot exceed 500'), findsOneWidget);
        });

    testWidgets('controller clear resets currency and amount',
            (tester) async {
          final controller = CurrencyInputController<String>(
            initialCurrency: 'USD',
            initialAmount: '25.50',
          );

          controller.clear();

          expect(controller.currency, isNull);
          expect(controller.amountText, '');
          expect(controller.amount, isNull);
        });

    testWidgets('amount parses commas correctly if model supports it',
            (tester) async {
          final controller = CurrencyInputController<String>(
            initialCurrency: 'USD',
            initialAmount: '1,234.56',
          );

          expect(controller.amount, 1234.56);
        });
  });

  group('CurrencyInputField<CurrencyCode>', () {
    testWidgets('renders initial enum currency from controller',
            (tester) async {
          final controller = CurrencyInputController<CurrencyCode>(
            initialCurrency: CurrencyCode.usd,
            initialAmount: '25.50',
          );

          await tester.pumpWidget(
            wrapWithMaterial(buildEnumField(controller: controller)),
          );

          expect(find.text('25.50'), findsOneWidget);
          expect(controller.currency, CurrencyCode.usd);
          expect(controller.amountText, '25.50');
          expect(controller.amount, 25.50);
        });

    testWidgets('fires enum currency change callback', (tester) async {
      CurrencyCode? latestCurrency;

      await tester.pumpWidget(
        wrapWithMaterial(
          buildEnumField(
            onCurrencyChanged: (currency) => latestCurrency = currency,
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<CurrencyCode>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('GBP').last);
      await tester.pumpAndSettle();

      expect(latestCurrency, CurrencyCode.gbp);
    });

    testWidgets('fires enum onChanged callback', (tester) async {
      CurrencyInputValue<CurrencyCode>? latestValue;

      await tester.pumpWidget(
        wrapWithMaterial(
          buildEnumField(
            controller: CurrencyInputController<CurrencyCode>(
              initialCurrency: CurrencyCode.usd,
            ),
            onChanged: (value) => latestValue = value,
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('currency_input_amount_field')),
        '45',
      );
      await tester.pump();

      expect(latestValue, isNotNull);
      expect(latestValue!.currency, CurrencyCode.usd);
      expect(latestValue!.amountText, '45');
      expect(latestValue!.amount, 45);
    });

    testWidgets('validates enum amount using custom validator',
            (tester) async {
          final formKey = GlobalKey<FormState>();
          final controller = CurrencyInputController<CurrencyCode>(
            initialCurrency: CurrencyCode.usd,
            initialAmount: '0',
          );

          await tester.pumpWidget(
            wrapWithMaterial(
              Form(
                key: formKey,
                child: buildEnumField(
                  controller: controller,
                  amountValidator: (value) {
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
            ),
          );

          final valid = formKey.currentState?.validate() ?? false;
          await tester.pump();

          expect(valid, isFalse);
          expect(find.text('Amount must be greater than 0'), findsOneWidget);
        });

    testWidgets('validates enum currency using custom validator',
            (tester) async {
          final formKey = GlobalKey<FormState>();
          final controller = CurrencyInputController<CurrencyCode>(
            initialCurrency: CurrencyCode.gbp,
            initialAmount: '25',
          );

          await tester.pumpWidget(
            wrapWithMaterial(
              Form(
                key: formKey,
                child: buildEnumField(
                  controller: controller,
                  currencyValidator: (currency) {
                    if (currency == CurrencyCode.gbp) {
                      return 'GBP is not supported';
                    }
                    return null;
                  },
                ),
              ),
            ),
          );

          final valid = formKey.currentState?.validate() ?? false;
          await tester.pump();

          expect(valid, isFalse);
          expect(find.text('GBP is not supported'), findsOneWidget);
        });
  });
}

enum CurrencyCode {
  zwg,
  usd,
  gbp,
}

extension CurrencyCodeX on CurrencyCode {
  String get code {
    switch (this) {
      case CurrencyCode.zwg:
        return 'ZWG';
      case CurrencyCode.usd:
        return 'USD';
      case CurrencyCode.gbp:
        return 'GBP';
    }
  }
}