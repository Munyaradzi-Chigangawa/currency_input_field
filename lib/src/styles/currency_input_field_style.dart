import 'package:flutter/material.dart';

@immutable
class CurrencyInputFieldStyle {
  const CurrencyInputFieldStyle({
    this.currencyDecoration,
    this.amountDecoration,
    this.currencyTextStyle,
    this.amountTextStyle,
    this.containerPadding = const EdgeInsets.all(6),
    this.spacing = 12,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.dividerColor,
  });

  final InputDecoration? currencyDecoration;
  final InputDecoration? amountDecoration;
  final TextStyle? currencyTextStyle;
  final TextStyle? amountTextStyle;
  final EdgeInsets containerPadding;
  final double spacing;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? dividerColor;
}