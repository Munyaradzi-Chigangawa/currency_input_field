import 'package:currency_input_field/currency_input_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyInputExampleApp());
}

class CurrencyInputExampleApp extends StatelessWidget {
  const CurrencyInputExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Input Field Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1D4ED8),
        useMaterial3: true,
      ),
      home: const CurrencyInputDemoPage(),
    );
  }
}

class CurrencyInputDemoPage extends StatelessWidget {
  const CurrencyInputDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Input Field'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _IntroSection(),
          SizedBox(height: 16),
          AdminPayoutExample(),
          SizedBox(height: 16),
          DonationExample(),
          SizedBox(height: 16),
          InvoiceCollectionExample(),
          SizedBox(height: 16),
          FixedInvoiceSettlementExample(),
          SizedBox(height: 16),
          QuickTransferInlineExample(),
          SizedBox(height: 16),
          WalletTopUpExample(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _IntroSection extends StatelessWidget {
  const _IntroSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: theme.textTheme.bodyMedium!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What this example app demonstrates',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'These examples are based on the actual component API: '
                    'generic currency types, controller support, amount and currency '
                    'validation hooks, adaptive/inline/stacked layouts, read-only mode, '
                    'and explicit sizing controls for compact or spacious UI.',
              ),
              const SizedBox(height: 12),
              const _FeatureBullet(
                text: 'String currencies and enum currencies',
              ),
              const _FeatureBullet(
                text: 'Compact admin-style and mobile-friendly configurations',
              ),
              const _FeatureBullet(
                text: 'Required fields, min/max checks, unsupported currencies',
              ),
              const _FeatureBullet(
                text: 'Cross-field business validation on submit',
              ),
              const _FeatureBullet(
                text: 'Prefilled controller-driven form state',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  const _FeatureBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class ExampleSection extends StatelessWidget {
  const ExampleSection({
    super.key,
    required this.title,
    required this.description,
    required this.whyItFits,
    required this.child,
  });

  final String title;
  final String description;
  final String whyItFits;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              whyItFits,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class SubmissionResult extends StatelessWidget {
  const SubmissionResult({
    super.key,
    required this.message,
    required this.isSuccess,
  });

  final String? message;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;
    final background = isSuccess
        ? scheme.primaryContainer
        : scheme.errorContainer;
    final foreground = isSuccess
        ? scheme.onPrimaryContainer
        : scheme.onErrorContainer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message!,
        style: TextStyle(color: foreground),
      ),
    );
  }
}

class AdminPayoutExample extends StatefulWidget {
  const AdminPayoutExample({super.key});

  @override
  State<AdminPayoutExample> createState() => _AdminPayoutExampleState();
}

class _AdminPayoutExampleState extends State<AdminPayoutExample> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CurrencyInputController<String>(
    initialCurrency: 'USD',
    initialAmount: '250',
  );

  String? _result;
  bool _isSuccess = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      if (!isValid) {
        _isSuccess = false;
        _result = 'Payout request not submitted. Fix the validation errors.';
        return;
      }

      _isSuccess = true;
      _result =
      'Payout queued: ${_controller.currency} ${_controller.amountText}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: '1. Finance admin payout form',
      description:
      'A back-office finance user is creating a partner payout. The form '
          'needs to stay compact, dense, and fast to scan on wider screens.',
      whyItFits:
      'This uses an inline layout, tighter padding, and strict payout rules. '
          'It demonstrates a more enterprise/admin-style configuration.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyInputField<String>(
              controller: _controller,
              currencies: const ['USD','GBP','ZWG','ZAR'],
              currencyLabelBuilder: (currency) => currency,
              currencyHintText: 'Settlement currency',
              monetaryHintText: 'Payout amount',
              layoutMode: CurrencyInputLayoutMode.inline,
              requireCurrency: true,
              requireAmount: true,
              useLabelText: true,
              containerPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              fieldHorizontalPadding: 10,
              fieldVerticalPadding: 8,
              inlineDividerHeight: 34,
              stackedDividerSpacing: 1,
              currencyFlex: 4,
              amountFlex: 6,
              amountValidator: (amountText) {
                final amount = double.tryParse(amountText);
                if (amount == null) {
                  return 'Enter a valid payout amount';
                }
                if (amount <= 0) {
                  return 'Amount must be greater than zero';
                }
                if (amount > 10000) {
                  return 'Admin payouts are capped at 10,000';
                }
                return null;
              },
              currencyValidator: (currency) {
                if (currency == 'ZAR') {
                  return 'ZAR payouts are handled in a separate flow';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send),
              label: const Text('Submit payout'),
            ),
            SubmissionResult(
              message: _result,
              isSuccess: _isSuccess,
            ),
          ],
        ),
      ),
    );
  }
}

class DonationExample extends StatefulWidget {
  const DonationExample({super.key});

  @override
  State<DonationExample> createState() => _DonationExampleState();
}

class _DonationExampleState extends State<DonationExample> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CurrencyInputController<String>();

  String? _result;
  bool _isSuccess = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      if (!isValid) {
        _isSuccess = false;
        _result = 'Donation not submitted. Review the highlighted fields.';
        return;
      }

      _isSuccess = true;
      _result =
      'Donation ready: ${_controller.currency} ${_controller.amountText}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: '2. Mobile donation flow',
      description:
      'A consumer donation screen needs large touch targets and very clear '
          'labels for first-time users on mobile devices.',
      whyItFits:
      'This uses stacked mode, larger vertical padding, and friendly hints. '
          'It feels more consumer/mobile-oriented than the admin example.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyInputField<String>(
              controller: _controller,
              currencies: const ['USD', 'GBP', 'ZAR'],
              currencyLabelBuilder: (currency) => currency,
              currencyHintText: 'Choose donation currency',
              monetaryHintText: 'Enter donation amount',
              layoutMode: CurrencyInputLayoutMode.stacked,
              requireCurrency: true,
              requireAmount: true,
              useLabelText: true,
              containerPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              fieldHorizontalPadding: 14,
              fieldVerticalPadding: 14,
              inlineDividerHeight: 40,
              stackedDividerSpacing: 4,
              amountValidator: (amountText) {
                final amount = double.tryParse(amountText);
                if (amount == null) {
                  return 'Enter a valid donation amount';
                }
                if (amount < 1) {
                  return 'Minimum donation is 1';
                }
                if (amount > 5000) {
                  return 'For larger donations, contact our team';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _submit,
              child: const Text('Donate now'),
            ),
            SubmissionResult(
              message: _result,
              isSuccess: _isSuccess,
            ),
          ],
        ),
      ),
    );
  }
}

enum InvoiceCurrency {
  usd,
  gbp,
  eur,
}

extension InvoiceCurrencyX on InvoiceCurrency {
  String get code {
    switch (this) {
      case InvoiceCurrency.usd:
        return 'USD';
      case InvoiceCurrency.gbp:
        return 'GBP';
      case InvoiceCurrency.eur:
        return 'EUR';
    }
  }
}

class InvoiceCollectionExample extends StatefulWidget {
  const InvoiceCollectionExample({super.key});

  @override
  State<InvoiceCollectionExample> createState() =>
      _InvoiceCollectionExampleState();
}

class _InvoiceCollectionExampleState extends State<InvoiceCollectionExample> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CurrencyInputController<InvoiceCurrency>(
    initialCurrency: InvoiceCurrency.usd,
  );

  String? _result;
  bool _isSuccess = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      if (!isValid) {
        _isSuccess = false;
        _result = 'Invoice payment request is invalid.';
        return;
      }

      _isSuccess = true;
      _result =
      'Invoice payment captured: ${_controller.currency?.code} ${_controller.amountText}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: '3. Cross-border invoice payment',
      description:
      'A SaaS billing team supports multiple settlement currencies and uses '
          'enum-backed values to keep the payment flow type-safe.',
      whyItFits:
      'This example shows the generic API in action with enum currencies, '
          'adaptive layout, and currency-specific business rules.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyInputField<InvoiceCurrency>(
              controller: _controller,
              currencies: InvoiceCurrency.values,
              currencyLabelBuilder: (currency) => currency.code,
              currencyHintText: 'Invoice currency',
              monetaryHintText: 'Invoice amount',
              layoutMode: CurrencyInputLayoutMode.adaptive,
              stackBreakpoint: 420,
              requireCurrency: true,
              requireAmount: true,
              useLabelText: false,
              containerPadding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              fieldHorizontalPadding: 12,
              fieldVerticalPadding: 10,
              inlineDividerHeight: 36,
              stackedDividerSpacing: 2,
              amountValidator: (amountText) {
                final amount = double.tryParse(amountText);
                if (amount == null) {
                  return 'Enter a valid invoice amount';
                }
                if (amount <= 0) {
                  return 'Amount must be greater than zero';
                }
                return null;
              },
              validator: (value) {
                final amount = value.amount ?? 0;
                switch (value.currency) {
                  case InvoiceCurrency.usd:
                    if (amount < 10) {
                      return 'Minimum USD invoice payment is 10';
                    }
                    break;
                  case InvoiceCurrency.gbp:
                    if (amount < 8) {
                      return 'Minimum GBP invoice payment is 8';
                    }
                    break;
                  case InvoiceCurrency.eur:
                    if (amount < 9) {
                      return 'Minimum EUR invoice payment is 9';
                    }
                    break;
                  case null:
                    break;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: _submit,
              child: const Text('Pay invoice'),
            ),
            SubmissionResult(
              message: _result,
              isSuccess: _isSuccess,
            ),
          ],
        ),
      ),
    );
  }
}

class FixedInvoiceSettlementExample extends StatefulWidget {
  const FixedInvoiceSettlementExample({super.key});

  @override
  State<FixedInvoiceSettlementExample> createState() =>
      _FixedInvoiceSettlementExampleState();
}

class _FixedInvoiceSettlementExampleState
    extends State<FixedInvoiceSettlementExample> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CurrencyInputController<String>(
    initialCurrency: 'USD',
    initialAmount: '149.99',
  );

  String? _result;
  bool _isSuccess = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      if (!isValid) {
        _isSuccess = false;
        _result = 'Settlement could not continue.';
        return;
      }

      _isSuccess = true;
      _result =
      'Invoice 10482 will be settled in ${_controller.currency} for ${_controller.amountText}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: '4. Fixed invoice settlement',
      description:
      'An invoice amount is already known from the backend, so the user can '
          'only choose settlement currency before confirming payment.',
      whyItFits:
      'This shows controller-prefilled state plus a read-only amount field. '
          'It is useful for review-and-confirm flows.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyInputField<String>(
              controller: _controller,
              currencies: const ['USD', 'EUR'],
              currencyLabelBuilder: (currency) => currency,
              currencyHintText: 'Settle in',
              monetaryHintText: 'Invoice total',
              layoutMode: CurrencyInputLayoutMode.inline,
              readOnlyAmount: true,
              requireCurrency: true,
              requireAmount: false,
              useLabelText: true,
              containerPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              fieldHorizontalPadding: 10,
              fieldVerticalPadding: 8,
              inlineDividerHeight: 34,
              stackedDividerSpacing: 1,
              amountTextInputAction: TextInputAction.done,
              currencyValidator: (currency) {
                if (currency == 'EUR') {
                  return 'EUR settlement is not enabled for this invoice';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _submit,
              child: const Text('Confirm settlement'),
            ),
            SubmissionResult(
              message: _result,
              isSuccess: _isSuccess,
            ),
          ],
        ),
      ),
    );
  }
}

class QuickTransferInlineExample extends StatefulWidget {
  const QuickTransferInlineExample({super.key});

  @override
  State<QuickTransferInlineExample> createState() =>
      _QuickTransferInlineExampleState();
}

class _QuickTransferInlineExampleState
    extends State<QuickTransferInlineExample> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CurrencyInputController<String>(
    initialCurrency: 'USD',
  );

  String? _result;
  bool _isSuccess = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      if (!isValid) {
        _isSuccess = false;
        _result = 'Transfer could not be submitted. Please fix the errors.';
        return;
      }

      _isSuccess = true;
      _result =
      'Quick transfer created: ${_controller.currency} ${_controller.amountText}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: '5. Quick transfer inline with icons',
      description:
      'A compact transfer form for dashboards and wallet apps where speed matters and the form needs to fit neatly into a tighter horizontal layout.',
      whyItFits:
      'This configuration uses inline layout, compact spacing, and icon-based input decoration to create a fast-entry form for desktop and admin-style screens.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyInputField<String>(
              controller: _controller,
              currencies: const ['USD', 'GBP', 'EUR'],
              currencyLabelBuilder: (currency) => currency,
              currencyHintText: 'Currency',
              monetaryHintText: 'Transfer amount',
              layoutMode: CurrencyInputLayoutMode.inline,
              requireCurrency: true,
              requireAmount: true,
              useLabelText: true,
              containerPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              fieldHorizontalPadding: 10,
              fieldVerticalPadding: 8,
              inlineDividerHeight: 34,
              stackedDividerSpacing: 1,
              currencyFlex: 4,
              amountFlex: 6,
              style: const CurrencyInputFieldStyle(
                currencyDecoration: InputDecoration(
                  labelText: 'Currency',
                  hintText: 'Choose currency',
                  prefixIcon: Icon(Icons.currency_exchange),
                ),
                amountDecoration: InputDecoration(
                  labelText: 'Transfer amount',
                  hintText: 'Enter amount',
                  prefixIcon: Icon(Icons.send_outlined),
                  suffixIcon: Icon(Icons.arrow_forward),
                ),
              ),
              amountValidator: (value) {
                final amount = double.tryParse(value);
                if (amount == null) {
                  return 'Enter a valid transfer amount';
                }
                if (amount <= 0) {
                  return 'Amount must be greater than zero';
                }
                if (amount > 5000) {
                  return 'Quick transfers are capped at 5000';
                }
                return null;
              },
              currencyValidator: (currency) {
                if (currency == 'EUR') {
                  return 'EUR quick transfers are not available';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.bolt),
              label: const Text('Send transfer'),
            ),
            SubmissionResult(
              message: _result,
              isSuccess: _isSuccess,
            ),
          ],
        ),
      ),
    );
  }
}

class WalletTopUpExample extends StatefulWidget {
  const WalletTopUpExample({super.key});

  @override
  State<WalletTopUpExample> createState() => _WalletTopUpExampleState();
}

class _WalletTopUpExampleState extends State<WalletTopUpExample> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CurrencyInputController<String>(
    initialCurrency: 'USD',
  );

  String? _result;
  bool _isSuccess = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      if (!isValid) {
        _isSuccess = false;
        _result = 'Top-up could not be submitted. Please fix the errors.';
        return;
      }

      _isSuccess = true;
      _result =
      'Wallet top-up created: ${_controller.currency} ${_controller.amountText}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: '6. Wallet top-up with icons',
      description:
      'A consumer wallet top-up flow that uses icons to make the form feel more guided and mobile-friendly.',
      whyItFits:
      'This configuration uses stacked layout, decorated inputs, and icon-led affordances to show how teams can build a more visual payment experience using the current API.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyInputField<String>(
              controller: _controller,
              currencies: const ['USD', 'GBP', 'ZWG'],
              currencyLabelBuilder: (currency) => currency,
              currencyHintText: 'Top-up currency',
              monetaryHintText: 'Top-up amount',
              layoutMode: CurrencyInputLayoutMode.stacked,
              requireCurrency: true,
              requireAmount: true,
              useLabelText: true,
              containerPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              fieldHorizontalPadding: 14,
              fieldVerticalPadding: 12,
              inlineDividerHeight: 40,
              stackedDividerSpacing: 4,
              style: const CurrencyInputFieldStyle(
                currencyDecoration: InputDecoration(
                  labelText: 'Top-up currency',
                  hintText: 'Choose currency',
                  prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                ),
                amountDecoration: InputDecoration(
                  labelText: 'Top-up amount',
                  hintText: 'Enter amount',
                  prefixIcon: Icon(Icons.payments_outlined),
                  suffixIcon: Icon(Icons.edit_outlined),
                ),
              ),
              amountValidator: (value) {
                final amount = double.tryParse(value);
                if (amount == null) {
                  return 'Enter a valid top-up amount';
                }
                if (amount < 5) {
                  return 'Minimum top-up is 5';
                }
                if (amount > 2000) {
                  return 'Maximum top-up is 2000';
                }
                return null;
              },
              currencyValidator: (currency) {
                if (currency == 'ZWG') {
                  return 'ZWG top-ups are currently unavailable';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.arrow_upward),
              label: const Text('Top up wallet'),
            ),
            SubmissionResult(
              message: _result,
              isSuccess: _isSuccess,
            ),
          ],
        ),
      ),
    );
  }
}