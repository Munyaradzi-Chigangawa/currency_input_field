import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyInputField extends StatefulWidget {
  final List<String> currencies;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<double> onAmountChanged;
  final String? Function(String?)? validateAmount;
  final String currencyHintText;
  final String monetaryHintText;

  final InputDecoration? currencyInputDecoration;
  final InputDecoration? amountInputDecoration;
  final TextStyle? currencyTextStyle;
  final TextStyle? amountTextStyle;
  final EdgeInsets? spacingBetweenFields;

  CurrencyInputField({
    required this.currencies,
    required this.onCurrencyChanged,
    required this.onAmountChanged,
    this.validateAmount,
    required this.currencyHintText,
    required this.monetaryHintText,

    this.currencyInputDecoration,
    this.amountInputDecoration,
    this.currencyTextStyle,
    this.amountTextStyle,
    this.spacingBetweenFields,
  });

  @override
  _CurrencyInputFieldState createState() => _CurrencyInputFieldState();
}

class _CurrencyInputFieldState extends State<CurrencyInputField> {
  String? selectedCurrency;
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // selectedCurrency = widget.currencies.first;
  }

  @override
  Widget build(BuildContext context) {

    final InputDecoration currencyDecoration = widget.currencyInputDecoration ??
        InputDecoration(
      hintText: widget.currencyHintText,
      labelText: widget.currencyHintText,
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    );

    final InputDecoration amountDecoration = widget.amountInputDecoration ?? InputDecoration(
      hintText: widget.monetaryHintText,
      labelText: widget.monetaryHintText,
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    );

    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              decoration: currencyDecoration,
              value: selectedCurrency,
              items: widget.currencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value;
                });
                widget.onCurrencyChanged(value!);
              },
            ),
          ),
          SizedBox(width: widget.spacingBetweenFields?.horizontal ?? 16.0),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: amountController,
              decoration: amountDecoration,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (widget.validateAmount != null) {
                  return widget.validateAmount!(value);
                }
                return null;
              },
              onChanged: (value) {
                widget.onAmountChanged(double.tryParse(value) ?? 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}