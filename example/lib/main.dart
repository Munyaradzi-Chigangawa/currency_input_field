import 'package:flutter/material.dart';
import 'package:currency_input_field/currency_input_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedCurrency = '';

  double enteredAmount = 0.0;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Currency Amount Input Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
          ),
        ),
      ),
    );
  }
}
