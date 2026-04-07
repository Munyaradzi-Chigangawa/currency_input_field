import 'package:flutter/material.dart';

/// Defines visual styling options for [CurrencyInputField].
///
/// Use this class to customize:
/// - input decorations
/// - text styles
/// - background and border colors
/// - border radius
/// - divider color
/// - default container padding
@immutable
class CurrencyInputFieldStyle {
  /// Creates a style configuration for [CurrencyInputField].
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

  /// Decoration applied to the currency dropdown field.
  final InputDecoration? currencyDecoration;

  /// Decoration applied to the amount text field.
  final InputDecoration? amountDecoration;

  /// Text style used by the currency dropdown field.
  final TextStyle? currencyTextStyle;

  /// Text style used by the amount text field.
  final TextStyle? amountTextStyle;

  /// Default padding used inside the outer container.
  final EdgeInsets containerPadding;

  /// General spacing value available to consumers of the style.
  final double spacing;

  /// Border radius used by the outer container.
  final BorderRadius borderRadius;

  /// Background color of the outer container.
  final Color? backgroundColor;

  /// Border color used in the default state.
  final Color? borderColor;

  /// Border color used when the amount field is focused.
  final Color? focusedBorderColor;

  /// Border color used when the field has a validation error.
  final Color? errorBorderColor;

  /// Divider color used between the currency and amount sections.
  final Color? dividerColor;
}
