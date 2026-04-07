# Currency Input Field

> A reusable Flutter widget for selecting a currency and entering a monetary amount, with validation, flexible layouts, generic currency support, and configurable sizing.

[![pub package](https://img.shields.io/pub/v/currency_input_field?style=for-the-badge)](https://pub.dev/packages/currency_input_field)
![GitHub last commit](https://img.shields.io/github/last-commit/Munyaradzi-Chigangawa/currency_input_field)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- Currency dropdown plus amount input in a single reusable component
- Supports `String`, enums, and custom currency models through generics
- Built-in validation support for:
  - currency selection
  - amount input
  - combined business-rule validation
- Inline, stacked, and adaptive layout modes
- Controller support for reading, updating, and clearing values
- Configurable sizing for compact or spacious UI
- Suitable for admin panels, mobile forms, donation flows, invoice screens, and payment forms

## Preview

The example app currently includes the following production-style scenarios:

| Scenario | What it demonstrates |
|---|---|
| **Finance admin payout form** | Compact inline layout, enterprise-style spacing, payout validation, and unsupported currency rules |
| **Mobile donation flow** | Stacked mobile-friendly layout, spacious padding, and donation-focused amount validation |
| **Cross-border invoice payment** | Enum-based currency support, adaptive layout, and currency-specific business rules |
| **Fixed invoice settlement** | Prefilled controller state, read-only amount handling, and review-and-confirm payment flow |
| **Quick transfer inline with icons** | Inline layout with decorated fields, compact fast-entry UX, and icon-based input styling |
| **Wallet top-up with icons** | Stacked consumer-style layout with icons, guided input decoration, and wallet top-up validation |

<p align="center">
  <img
    src="https://raw.githubusercontent.com/Munyaradzi-Chigangawa/currency_input_field/master/screenshots/CurrencyInputField.gif"
    alt="Currency Input Field full component showcase"
    width="900"
  />
</p>

<table>
  <tr>
    <td align="center" valign="top" width="50%">
      <h3>Finance admin payout form</h3>
      <p>Compact inline layout, enterprise-style spacing, payout validation, and unsupported currency rules.</p>
      <img
        src="https://raw.githubusercontent.com/Munyaradzi-Chigangawa/currency_input_field/master/screenshots/AdminPayoutExample.png"
        alt="Finance admin payout form"
        width="100%"
      />
    </td>
    <td align="center" valign="top" width="50%">
      <h3>Mobile donation flow</h3>
      <p>Stacked mobile-friendly layout, spacious padding, and donation-focused amount validation.</p>
      <img
        src="https://raw.githubusercontent.com/Munyaradzi-Chigangawa/currency_input_field/master/screenshots/DonationExample.png"
        alt="Mobile donation flow"
        width="100%"
      />
    </td>
  </tr>
  <tr>
    <td align="center" valign="top" width="50%">
      <h3>Cross-border invoice payment</h3>
      <p>Enum-based currency support, adaptive layout, and currency-specific business rules.</p>
      <img
        src="https://raw.githubusercontent.com/Munyaradzi-Chigangawa/currency_input_field/master/screenshots/InvoiceCollectionExample.png"
        alt="Cross-border invoice payment"
        width="100%"
      />
    </td>
    <td align="center" valign="top" width="50%">
      <h3>Fixed invoice settlement</h3>
      <p>Prefilled controller state, read-only amount handling, and review-and-confirm payment flow.</p>
      <img
        src="https://raw.githubusercontent.com/Munyaradzi-Chigangawa/currency_input_field/master/screenshots/FixedInvoiceSettlementExample.png"
        alt="Fixed invoice settlement"
        width="100%"
      />
    </td>
  </tr>
  <tr>
    <td align="center" valign="top" width="50%">
      <h3>Quick transfer inline with icons</h3>
      <p>Inline layout with decorated fields, compact fast-entry UX, and icon-based input styling.</p>
      <img
        src="https://raw.githubusercontent.com/Munyaradzi-Chigangawa/currency_input_field/master/screenshots/QuickTransferInlineExample.png"
        alt="Quick transfer inline with icons"
        width="100%"
      />
    </td>
    <td align="center" valign="top" width="50%">
      <h3>Wallet top-up with icons</h3>
      <p>Stacked consumer-style layout with icons, guided input decoration, and wallet top-up validation.</p>
      <img
        src="https://raw.githubusercontent.com/Munyaradzi-Chigangawa/currency_input_field/master/screenshots/WalletTopUpExample.png"
        alt="Wallet top-up with icons"
        width="100%"
      />
    </td>
  </tr>
</table>

### Preview coverage

- Inline layout
- Stacked layout
- Adaptive layout
- Enum-based usage
- Validation states
- Compact styling
- Spacious styling
- Read-only amount configuration
- Controller-based prefilled values
- Input decoration with icons
- Enterprise/admin-style forms
- Consumer/mobile-friendly forms

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  currency_input_field: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Import

```dart
import 'package:currency_input_field/currency_input_field.dart';
```

## Basic Usage

```dart
import 'package:currency_input_field/currency_input_field.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Currency Input Field Example')),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: BasicExample(),
        ),
      ),
    );
  }
}

class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CurrencyInputController<String>(
    initialCurrency: 'USD',
  );

  String? result;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      if (!isValid) {
        result = 'Please fix the validation errors.';
        return;
      }

      result = 'Submitted: ${_controller.currency} ${_controller.amountText}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CurrencyInputField<String>(
            controller: _controller,
            currencies: const ['USD', 'GBP', 'ZWG'],
            currencyLabelBuilder: (currency) => currency,
            currencyHintText: 'Currency',
            monetaryHintText: 'Amount',
            containerPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            fieldHorizontalPadding: 10,
            fieldVerticalPadding: 8,
            inlineDividerHeight: 32,
            stackedDividerSpacing: 1,
            useLabelText: true,
            amountValidator: (value) {
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Enter an amount greater than zero';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),
          if (result != null) ...[
            const SizedBox(height: 12),
            Text(result!),
          ],
        ],
      ),
    );
  }
}
```

## Using an Enum

```dart
enum CurrencyCode {
  usd,
  gbp,
  zwg,
}

extension CurrencyCodeX on CurrencyCode {
  String get code {
    switch (this) {
      case CurrencyCode.usd:
        return 'USD';
      case CurrencyCode.gbp:
        return 'GBP';
      case CurrencyCode.zwg:
        return 'ZWG';
    }
  }
}

final controller = CurrencyInputController<CurrencyCode>(
  initialCurrency: CurrencyCode.usd,
);

CurrencyInputField<CurrencyCode>(
  controller: controller,
  currencies: CurrencyCode.values,
  currencyLabelBuilder: (currency) => currency.code,
  currencyHintText: 'Currency',
  monetaryHintText: 'Amount',
  containerPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
  fieldHorizontalPadding: 10,
  fieldVerticalPadding: 8,
  inlineDividerHeight: 32,
  stackedDividerSpacing: 1,
  useLabelText: false,
)
```

## Validation Options

The widget supports three levels of validation.

### `currencyValidator`

Use this for currency-specific restrictions.

```dart
currencyValidator: (currency) {
  if (currency == 'ZAR') {
    return 'ZAR is not supported for this flow';
  }
  return null;
},
```

### `amountValidator`

Use this for amount-only rules.

```dart
amountValidator: (value) {
  final amount = double.tryParse(value);
  if (amount == null || amount <= 0) {
    return 'Enter a valid amount';
  }
  if (amount < 5) {
    return 'Minimum amount is 5';
  }
  return null;
},
```

### `validator`

Use this for combined business rules involving both currency and amount.

```dart
validator: (value) {
  if (value.currency == 'USD' && (value.amount ?? 0) > 500) {
    return 'USD amount cannot exceed 500';
  }
  return null;
},
```

## Layout Modes

### Inline

Best for admin dashboards and wider layouts.

```dart
layoutMode: CurrencyInputLayoutMode.inline,
```

### Stacked

Best for mobile-first forms and narrow screens.

```dart
layoutMode: CurrencyInputLayoutMode.stacked,
```

### Adaptive

Switches automatically based on available width.

```dart
layoutMode: CurrencyInputLayoutMode.adaptive,
stackBreakpoint: 360,
```

## Controller Usage

```dart
final controller = CurrencyInputController<String>(
  initialCurrency: 'USD',
  initialAmount: '25.00',
);

// Read current values
controller.currency;
controller.amountText;
controller.amount;

// Update values
controller.setCurrency('GBP');
controller.setAmountText('80');

// Clear values
controller.clear();
```

## Design and Layout Customization

`CurrencyInputField<T>` is designed to support different UI styles, from compact admin forms to spacious mobile-friendly flows.

This section documents the parameters you can adjust to achieve the design you want.

---

### 1. Layout Mode

Controls whether the currency and amount fields appear side by side or stacked.

#### `layoutMode`

```dart
layoutMode: CurrencyInputLayoutMode.adaptive
```

Available values:

- `CurrencyInputLayoutMode.inline`  
  Always shows the fields side by side.
- `CurrencyInputLayoutMode.stacked`  
  Always shows the currency field above the amount field.
- `CurrencyInputLayoutMode.adaptive`  
  Switches between inline and stacked depending on available width.

#### `stackBreakpoint`

```dart
stackBreakpoint: 360
```

Used only when `layoutMode` is `adaptive`.

If the available width is less than `stackBreakpoint`, the widget switches to stacked mode.

**Recommended usage**
- Use `inline` for dashboards, admin portals, and desktop forms
- Use `stacked` for mobile-first forms and narrow UIs
- Use `adaptive` when you want a single responsive widget

---

### 2. Outer Container Size

These parameters control the size and feel of the main wrapper around both inputs.

#### `containerPadding`

```dart
containerPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0)
```

Controls padding inside the outer container.

Use smaller values for a tighter look, and larger values for a more spacious look.

**Examples**

Compact:

```dart
containerPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0)
```

Spacious:

```dart
containerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
```

---

### 3. Inner Field Padding

These parameters control how tall and wide each field feels.

#### `fieldHorizontalPadding`

```dart
fieldHorizontalPadding: 10
```

Controls left and right padding inside both inputs.

#### `fieldVerticalPadding`

```dart
fieldVerticalPadding: 8
```

Controls top and bottom padding inside both inputs.

This is one of the most important parameters for reducing or increasing vertical size.

**Examples**

Compact:

```dart
fieldHorizontalPadding: 10,
fieldVerticalPadding: 8,
```

Spacious:

```dart
fieldHorizontalPadding: 14,
fieldVerticalPadding: 14,
```

---

### 4. Divider Sizing

These parameters affect the visual separation between the currency and amount fields.

#### `inlineDividerHeight`

```dart
inlineDividerHeight: 32
```

Height of the vertical divider in inline layout.

#### `stackedDividerSpacing`

```dart
stackedDividerSpacing: 1
```

Height used by the divider between the top and bottom fields in stacked mode.

Smaller values create a tighter layout.

---

### 5. Labels vs Hints

#### `useLabelText`

```dart
useLabelText: true
```

Controls whether the provided hint texts are shown as floating labels.

When `true`, the widget uses:

- `currencyHintText`
- `monetaryHintText`

as label text.

When `false`, they behave like standard hints.

**Examples**

Label style:

```dart
currencyHintText: 'Currency',
monetaryHintText: 'Amount',
useLabelText: true,
```

Hint-only style:

```dart
currencyHintText: 'Select currency',
monetaryHintText: 'Enter amount',
useLabelText: false,
```

**Recommended usage**
- Use `useLabelText: true` for enterprise/admin-style forms
- Use `useLabelText: false` for lighter consumer-style layouts

---

### 6. Field Width Balance

When using inline layout, you can control how much horizontal space each section gets.

#### `currencyFlex`

```dart
currencyFlex: 4
```

#### `amountFlex`

```dart
amountFlex: 6
```

These are passed into `Expanded` widgets in inline mode.

**Examples**

Balanced:

```dart
currencyFlex: 5,
amountFlex: 5,
```

Amount gets more space:

```dart
currencyFlex: 4,
amountFlex: 6,
```

---

### 7. Dropdown Appearance

These parameters affect the currency dropdown overlay.

#### `dropdownBorderRadius`

```dart
dropdownBorderRadius: BorderRadius.circular(12)
```

Controls the dropdown menu shape.

#### `dropdownMenuMaxHeight`

```dart
dropdownMenuMaxHeight: 280
```

Limits the maximum height of the dropdown menu.

Useful when you support many currencies and want a more controlled menu size.

---

### 8. Styling Support

#### `style`

```dart
style: const CurrencyInputFieldStyle(...)
```

This allows deeper visual styling.

From the current implementation, `style` is used for:

- `backgroundColor`
- `borderRadius`
- `borderColor`
- `focusedBorderColor`
- `errorBorderColor`
- `dividerColor`
- `currencyDecoration`
- `amountDecoration`
- `currencyTextStyle`
- `amountTextStyle`

This is the main place to customize colors, border radius, input decorations, and text styles.

---

### 9. UX and Behavior Options

These are not purely visual, but they affect how the component feels in real usage.

#### `enabled`

```dart
enabled: true
```

Disables both inputs when set to `false`.

#### `readOnlyAmount`

```dart
readOnlyAmount: true
```

Makes the amount input read-only while still displaying its value.

Useful for review or fixed-amount payment flows.

#### `autofocusAmount`

```dart
autofocusAmount: true
```

Focuses the amount field automatically when the widget appears.

Useful for fast-entry forms.

---

### 10. Keyboard and Input Behavior

These parameters affect the amount field input experience.

#### `amountKeyboardType`

```dart
amountKeyboardType: const TextInputType.numberWithOptions(decimal: true)
```

Controls the keyboard shown for the amount field.

#### `amountTextInputAction`

```dart
amountTextInputAction: TextInputAction.done
```

Controls the keyboard action button.

#### `decimalDigits`

```dart
decimalDigits: 2
```

Controls allowed decimal precision.

#### `allowNegative`

```dart
allowNegative: false
```

Allows or disallows negative values.

#### `amountInputFormatters`

```dart
amountInputFormatters: [...]
```

Lets you pass additional input formatters.

---

### 11. Practical Design Presets

#### Compact admin / dashboard style

```dart
CurrencyInputField<String>(
  currencies: const ['USD', 'EUR', 'GBP'],
  currencyLabelBuilder: (currency) => currency,
  currencyHintText: 'Currency',
  monetaryHintText: 'Amount',
  layoutMode: CurrencyInputLayoutMode.inline,
  useLabelText: true,
  containerPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
  fieldHorizontalPadding: 10,
  fieldVerticalPadding: 8,
  inlineDividerHeight: 32,
  stackedDividerSpacing: 1,
  currencyFlex: 4,
  amountFlex: 6,
)
```

#### Spacious mobile / consumer style

```dart
CurrencyInputField<String>(
  currencies: const ['USD', 'EUR', 'GBP'],
  currencyLabelBuilder: (currency) => currency,
  currencyHintText: 'Choose currency',
  monetaryHintText: 'Enter amount',
  layoutMode: CurrencyInputLayoutMode.stacked,
  useLabelText: true,
  containerPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  fieldHorizontalPadding: 14,
  fieldVerticalPadding: 14,
  inlineDividerHeight: 40,
  stackedDividerSpacing: 4,
)
```

#### Lightweight simple style

```dart
CurrencyInputField<String>(
  currencies: const ['USD', 'EUR'],
  currencyLabelBuilder: (currency) => currency,
  currencyHintText: 'Currency',
  monetaryHintText: 'Amount',
  layoutMode: CurrencyInputLayoutMode.inline,
  useLabelText: false,
  containerPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
  fieldHorizontalPadding: 10,
  fieldVerticalPadding: 8,
  inlineDividerHeight: 32,
  stackedDividerSpacing: 1,
)
```

---

### 12. Quick Reference

| Parameter | What it affects |
|---|---|
| `layoutMode` | Inline, stacked, or adaptive layout |
| `stackBreakpoint` | Width threshold for adaptive layout |
| `containerPadding` | Padding inside the outer wrapper |
| `fieldHorizontalPadding` | Left/right padding inside each field |
| `fieldVerticalPadding` | Top/bottom padding inside each field |
| `inlineDividerHeight` | Vertical divider height in inline mode |
| `stackedDividerSpacing` | Divider spacing in stacked mode |
| `useLabelText` | Floating labels vs hint-only behavior |
| `currencyFlex` | Width share of the currency field in inline mode |
| `amountFlex` | Width share of the amount field in inline mode |
| `dropdownBorderRadius` | Dropdown menu corner radius |
| `dropdownMenuMaxHeight` | Maximum dropdown height |
| `style` | Colors, decorations, text styles, border radius |
| `enabled` | Enabled/disabled state |
| `readOnlyAmount` | Makes amount read-only |
| `autofocusAmount` | Automatically focuses amount field |
| `amountKeyboardType` | Keyboard type for amount input |
| `amountTextInputAction` | Keyboard action button |
| `decimalDigits` | Decimal precision |
| `allowNegative` | Allows negative values |
| `amountInputFormatters` | Additional input formatters |

---

### 13. Recommended Starting Points

If you are unsure where to start:

- For admin or enterprise UIs:
  - `layoutMode: CurrencyInputLayoutMode.inline`
  - `useLabelText: true`
  - smaller paddings

- For mobile and consumer UIs:
  - `layoutMode: CurrencyInputLayoutMode.stacked`
  - `useLabelText: true`
  - larger vertical paddings

- For reusable responsive forms:
  - `layoutMode: CurrencyInputLayoutMode.adaptive`
  - `stackBreakpoint: 360`

## Common Use Cases

- Payment and checkout forms
- Donation and contribution screens
- Back-office payout tools
- Invoice payment and settlement flows
- Admin dashboards
- Mobile finance apps

## Package Example

See the `/example` app for real-world scenarios, including:

- admin payout form
- mobile donation flow
- enum-based invoice currency selection
- read-only invoice settlement

## Breaking Changes in 0.1.0

Version `0.1.0` introduces breaking API changes from `0.0.5`, including:

- generic currency type support
- updated validation API using `amountValidator`
- explicit sizing configuration
- refreshed production-oriented example patterns

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

Munyaradzi Chigangawa  
Website: https://munyaradzichigangawa.co.zw
