# Currency Input Field

<img src="https://img.shields.io/pub/v/currency_input_field?style=for-the-badge">
<img src="https://img.shields.io/github/last-commit/Munyaradzi-Chigangawa/currency_input_field">
<img src="https://img.shields.io/twitter/url?label=Munyaradzi Chigangawa&style=social&url=https%3A%2F%2Ftwitter.com%2Fmchigangawa">

[![License: MIT][license_badge]][license_link]
![Coverage](./badge.svg)

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT


A customizable Flutter widget for inputting currency and amount values. This widget is designed to provide an intuitive and user-friendly way to input currency types and their corresponding amounts with validation.

## Features

- Dropdown selection for currencies
- Numeric input field for amounts
- Customizable hint texts
- Validation for amount input
- Seamless integration with other Flutter components

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  currency_input_field: ^0.0.1
```

### or
```shell
flutter pub add currency_input_field
```

## Usage

Import the CurrencyInputField widget into your Dart file:

```dart
import 'package:currency_input_field/currency_input_field.dart';
```

## Example

Here is a simple example of how to use the CurrencyInputField widget:

```dart
import 'package:flutter/material.dart';
import 'package:currency_input_field/currency_input_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Currency Amount Input Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CurrencyInputExample(),
        ),
      ),
    );
  }
}

class CurrencyInputExample extends StatefulWidget {
  @override
  _CurrencyInputExampleState createState() => _CurrencyInputExampleState();
}

class _CurrencyInputExampleState extends State<CurrencyInputExample> {
  String selectedCurrency = 'ZMW';
  double enteredAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurrencyInputField(
          currencyHintText: "Currency",
          monetaryHintText: "Amount",
          currencies: ['ZMW', 'MWK', 'KES', 'ZAR', 'BWP', 'GBP', 'ZWL', 'USD'],
          onCurrencyChanged: (currency) {
            setState(() {
              selectedCurrency = currency;
            });
            print('Selected currency: $currency');
          },
          onAmountChanged: (amount) {
            setState(() {
              enteredAmount = amount;
            });
            print('Entered amount: $amount');
          },
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
        ),
        SizedBox(height: 20.0),
        Text(
          "Selected Currency: $selectedCurrency",
          style: TextStyle(fontSize: 16.0),
        ),
        Text(
          "Entered Amount: $enteredAmount",
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
```

## Preview 
[![Currency Input Field](https://raw.githubusercontent.com/Munyaradzi-Chigangawa/currency_input_field/master/screenshots/Screenshot_20240721_204210.png)](https://www.munyaradzichigangawa.co.zw)


## Advanced Usage
```dart
CurrencyInputField(
  currencyHintText: "Select Currency",
  monetaryHintText: "Enter Amount",
  currencies: ['USD', 'EUR', 'JPY', 'GBP'],
  onCurrencyChanged: (currency) {
    // Handle currency change
  },
  onAmountChanged: (amount) {
    // Handle amount change
  },
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
),

```

## Parameters

| Parameter | Description |
| --- | --- |
| currencyHintText | The hint text for the currency dropdown |
| monetaryHintText | The hint text for the amount input field |
| currencies | The list of currency codes to be displayed in the dropdown |
| onCurrencyChanged | A callback function that is called when the currency is changed |
| onAmountChanged | A callback function that is called when the amount is changed |
| validateAmount | A function that validates the amount input field |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
