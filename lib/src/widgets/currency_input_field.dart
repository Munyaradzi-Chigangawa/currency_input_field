import 'package:currency_input_field/currency_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Controls how the currency and amount inputs are arranged.
enum CurrencyInputLayoutMode {
  /// Automatically switches between inline and stacked layout
  /// depending on the available width.
  adaptive,

  /// Always displays the currency and amount fields side by side.
  inline,

  /// Always displays the currency field above the amount field.
  stacked,
}

/// A configurable input widget for selecting a currency and entering
/// a monetary amount.
///
/// This widget supports:
/// - generic currency types
/// - inline, stacked, and adaptive layouts
/// - controller-driven state
/// - amount, currency, and cross-field validation
/// - configurable sizing and layout behavior
class CurrencyInputField<T> extends StatefulWidget {
  /// Creates a currency input field.
  const CurrencyInputField({
    super.key,
    required this.currencies,
    required this.currencyLabelBuilder,
    required this.currencyHintText,
    required this.monetaryHintText,
    required this.containerPadding,
    required this.fieldHorizontalPadding,
    required this.fieldVerticalPadding,
    required this.inlineDividerHeight,
    required this.stackedDividerSpacing,
    required this.useLabelText,
    this.controller,
    this.initialCurrency,
    this.initialAmount = '',
    this.onChanged,
    this.onCurrencyChanged,
    this.onAmountChanged,
    this.validator,
    this.currencyValidator,
    this.amountValidator,
    this.requireCurrency = true,
    this.requireAmount = true,
    this.enabled = true,
    this.readOnlyAmount = false,
    this.autofocusAmount = false,
    this.decimalDigits = 2,
    this.allowNegative = false,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.layoutMode = CurrencyInputLayoutMode.adaptive,
    this.stackBreakpoint = 360,
    this.currencyFlex = 4,
    this.amountFlex = 6,
    this.amountKeyboardType =
        const TextInputType.numberWithOptions(decimal: true),
    this.amountTextInputAction,
    this.amountFocusNode,
    this.amountInputFormatters,
    this.dropdownBorderRadius,
    this.dropdownMenuMaxHeight,
    this.style,
  })  : assert(currencies.length > 0, 'currencies cannot be empty'),
        assert(decimalDigits >= 0, 'decimalDigits must be >= 0'),
        assert(stackBreakpoint > 0, 'stackBreakpoint must be > 0'),
        assert(currencyFlex > 0, 'currencyFlex must be > 0'),
        assert(amountFlex > 0, 'amountFlex must be > 0'),
        assert(
          fieldHorizontalPadding >= 0,
          'fieldHorizontalPadding must be >= 0',
        ),
        assert(
          fieldVerticalPadding >= 0,
          'fieldVerticalPadding must be >= 0',
        ),
        assert(
          inlineDividerHeight >= 0,
          'inlineDividerHeight must be >= 0',
        ),
        assert(
          stackedDividerSpacing >= 0,
          'stackedDividerSpacing must be >= 0',
        );

  /// The list of selectable currency values.
  final List<T> currencies;

  /// Builds the visible label for each currency option.
  final String Function(T currency) currencyLabelBuilder;

  /// Optional controller used to read and update the widget state externally.
  final CurrencyInputController<T>? controller;

  /// The initially selected currency when no controller is provided.
  final T? initialCurrency;

  /// The initial amount text when no controller is provided.
  final String initialAmount;

  /// Called whenever the combined value changes.
  final ValueChanged<CurrencyInputValue<T>>? onChanged;

  /// Called whenever the selected currency changes.
  final ValueChanged<T?>? onCurrencyChanged;

  /// Called whenever the parsed amount changes.
  final ValueChanged<double>? onAmountChanged;

  /// Validates the combined currency and amount value.
  ///
  /// This is useful for cross-field business rules.
  final String? Function(CurrencyInputValue<T> value)? validator;

  /// Validates the selected currency.
  final String? Function(T? currency)? currencyValidator;

  /// Validates the raw amount text.
  final String? Function(String amountText)? amountValidator;

  /// Whether a currency must be selected.
  final bool requireCurrency;

  /// Whether an amount must be entered.
  final bool requireAmount;

  /// Hint or label text for the currency input.
  final String currencyHintText;

  /// Hint or label text for the amount input.
  final String monetaryHintText;

  /// Whether the widget is enabled.
  final bool enabled;

  /// Whether the amount field is read-only.
  final bool readOnlyAmount;

  /// Whether the amount field should receive focus automatically.
  final bool autofocusAmount;

  /// The maximum number of decimal digits allowed in the amount field.
  final int decimalDigits;

  /// Whether negative values are allowed in the amount field.
  final bool allowNegative;

  /// Controls when validation messages are shown.
  final AutovalidateMode autovalidateMode;

  /// Controls whether the fields are shown inline, stacked, or adaptively.
  final CurrencyInputLayoutMode layoutMode;

  /// Width threshold used by adaptive layout to switch to stacked mode.
  final double stackBreakpoint;

  /// Flex value for the currency field in inline layout.
  final int currencyFlex;

  /// Flex value for the amount field in inline layout.
  final int amountFlex;

  /// Keyboard type used by the amount field.
  final TextInputType amountKeyboardType;

  /// Keyboard action used by the amount field.
  final TextInputAction? amountTextInputAction;

  /// Optional focus node for the amount field.
  final FocusNode? amountFocusNode;

  /// Additional input formatters for the amount field.
  final List<TextInputFormatter>? amountInputFormatters;

  /// Border radius used by the currency dropdown menu.
  final BorderRadius? dropdownBorderRadius;

  /// Maximum height of the currency dropdown menu.
  final double? dropdownMenuMaxHeight;

  /// Optional style configuration for the widget.
  final CurrencyInputFieldStyle? style;

  /// Padding inside the outer container that wraps both fields.
  final EdgeInsetsGeometry containerPadding;

  /// Horizontal padding inside the currency and amount fields.
  final double fieldHorizontalPadding;

  /// Vertical padding inside the currency and amount fields.
  final double fieldVerticalPadding;

  /// Height of the divider used in inline layout.
  final double inlineDividerHeight;

  /// Divider spacing used in stacked layout.
  final double stackedDividerSpacing;

  /// Whether hint texts should also be used as floating labels.
  final bool useLabelText;

  @override
  State<CurrencyInputField<T>> createState() => _CurrencyInputFieldState<T>();
}

class _CurrencyInputFieldState<T> extends State<CurrencyInputField<T>> {
  late final CurrencyInputController<T> _internalController;
  late final TextEditingController _amountController;
  late final FocusNode _internalAmountFocusNode;

  CurrencyInputController<T> get _controller =>
      widget.controller ?? _internalController;

  FocusNode get _amountFocusNode =>
      widget.amountFocusNode ?? _internalAmountFocusNode;

  CurrencyInputFieldStyle get _style =>
      widget.style ?? const CurrencyInputFieldStyle();

  bool get _ownsController => widget.controller == null;
  bool get _ownsFocusNode => widget.amountFocusNode == null;

  @override
  void initState() {
    super.initState();

    _internalController = CurrencyInputController<T>(
      initialCurrency: widget.initialCurrency,
      initialAmount: widget.initialAmount,
    );

    _amountController = TextEditingController(text: _controller.amountText);
    _internalAmountFocusNode = FocusNode();

    _controller.addListener(_handleControllerChanged);
    _amountFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant CurrencyInputField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _controller.addListener(_handleControllerChanged);

      if (_amountController.text != _controller.amountText) {
        _amountController.value = _amountController.value.copyWith(
          text: _controller.amountText,
          selection: TextSelection.collapsed(
            offset: _controller.amountText.length,
          ),
          composing: TextRange.empty,
        );
      }
    }

    if (oldWidget.amountFocusNode != widget.amountFocusNode) {
      final previousFocusNode =
          oldWidget.amountFocusNode ?? _internalAmountFocusNode;
      previousFocusNode.removeListener(_handleFocusChanged);
      _amountFocusNode.addListener(_handleFocusChanged);
    }
  }

  void _handleControllerChanged() {
    if (_amountController.text != _controller.amountText) {
      _amountController.value = _amountController.value.copyWith(
        text: _controller.amountText,
        selection: TextSelection.collapsed(
          offset: _controller.amountText.length,
        ),
        composing: TextRange.empty,
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String? _defaultValidate(CurrencyInputValue<T> value) {
    if (widget.requireCurrency && value.currency == null) {
      return 'Please select a currency';
    }

    if (widget.requireAmount && value.amountText.trim().isEmpty) {
      return 'Please enter an amount';
    }

    if (value.amountText.trim().isNotEmpty && value.amount == null) {
      return 'Please enter a valid amount';
    }

    return null;
  }

  String? _validate(CurrencyInputValue<T>? value) {
    final current = value ?? _controller.value;

    final defaultError = _defaultValidate(current);
    if (defaultError != null) return defaultError;

    final currencyError = widget.currencyValidator?.call(current.currency);
    if (currencyError != null) return currencyError;

    final amountError = widget.amountValidator?.call(current.amountText);
    if (amountError != null) return amountError;

    return widget.validator?.call(current);
  }

  void _notifyChanged() {
    final value = _controller.value;

    widget.onChanged?.call(value);
    widget.onCurrencyChanged?.call(value.currency);

    if (value.amount != null) {
      widget.onAmountChanged?.call(value.amount!);
    }
  }

  bool _shouldStack(double width) {
    switch (widget.layoutMode) {
      case CurrencyInputLayoutMode.inline:
        return false;
      case CurrencyInputLayoutMode.stacked:
        return true;
      case CurrencyInputLayoutMode.adaptive:
        return width < widget.stackBreakpoint;
    }
  }

  InputDecoration _currencyDecoration() {
    final base = _style.currencyDecoration ?? const InputDecoration();

    return base.copyWith(
      hintText: widget.currencyHintText,
      labelText: widget.useLabelText ? widget.currencyHintText : null,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        horizontal: widget.fieldHorizontalPadding,
        vertical: widget.fieldVerticalPadding,
      ),
      isDense: true,
    );
  }

  InputDecoration _amountDecoration() {
    final base = _style.amountDecoration ?? const InputDecoration();

    return base.copyWith(
      hintText: widget.monetaryHintText,
      labelText: widget.useLabelText ? widget.monetaryHintText : null,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        horizontal: widget.fieldHorizontalPadding,
        vertical: widget.fieldVerticalPadding,
      ),
      isDense: true,
    );
  }

  Widget _buildCurrencyField(FormFieldState<CurrencyInputValue<T>> field) {
    return DropdownButtonFormField<T>(
      initialValue: _controller.currency != null &&
              widget.currencies.contains(_controller.currency)
          ? _controller.currency
          : null,
      isExpanded: true,
      borderRadius: widget.dropdownBorderRadius ?? BorderRadius.circular(12),
      menuMaxHeight: widget.dropdownMenuMaxHeight,
      style: _style.currencyTextStyle,
      decoration: _currencyDecoration(),
      items: widget.currencies
          .map(
            (currency) => DropdownMenuItem<T>(
              value: currency,
              child: Text(
                widget.currencyLabelBuilder(currency),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: widget.enabled
          ? (value) {
              _controller.setCurrency(value);
              field.didChange(_controller.value);
              _notifyChanged();
              setState(() {});
            }
          : null,
    );
  }

  Widget _buildAmountField(FormFieldState<CurrencyInputValue<T>> field) {
    return TextField(
      key: const Key('currency_input_amount_field'),
      controller: _amountController,
      focusNode: _amountFocusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnlyAmount,
      autofocus: widget.autofocusAmount,
      style: _style.amountTextStyle,
      keyboardType: widget.amountKeyboardType,
      textInputAction: widget.amountTextInputAction,
      decoration: _amountDecoration(),
      inputFormatters: [
        DecimalTextInputFormatter(
          decimalRange: widget.decimalDigits,
          allowNegative: widget.allowNegative,
        ),
        ...?widget.amountInputFormatters,
      ],
      onChanged: (value) {
        _controller.setAmountText(value);
        field.didChange(_controller.value);
        _notifyChanged();
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    _amountFocusNode.removeListener(_handleFocusChanged);

    if (_ownsController) {
      _internalController.dispose();
    }

    _amountController.dispose();

    if (_ownsFocusNode) {
      _internalAmountFocusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<CurrencyInputValue<T>>(
      initialValue: _controller.value,
      validator: _validate,
      autovalidateMode: widget.autovalidateMode,
      builder: (field) {
        final hasError = field.errorText != null;
        final shouldStack = _shouldStack(MediaQuery.sizeOf(context).width);

        final borderColor = hasError
            ? (_style.errorBorderColor ?? theme.colorScheme.error)
            : (_amountFocusNode.hasFocus
                ? (_style.focusedBorderColor ?? theme.colorScheme.primary)
                : (_style.borderColor ?? theme.dividerColor));

        final dividerColor = _style.dividerColor ?? theme.dividerColor;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: widget.containerPadding,
              decoration: BoxDecoration(
                color: _style.backgroundColor,
                borderRadius: _style.borderRadius,
                border: Border.all(color: borderColor),
              ),
              child: shouldStack
                  ? Column(
                      key: const Key('currency_input_stacked_layout'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCurrencyField(field),
                        Divider(
                          height: widget.stackedDividerSpacing,
                          thickness: 1,
                          color: dividerColor,
                        ),
                        _buildAmountField(field),
                      ],
                    )
                  : Row(
                      key: const Key('currency_input_inline_layout'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: widget.currencyFlex,
                          child: _buildCurrencyField(field),
                        ),
                        Container(
                          width: 1,
                          height: widget.inlineDividerHeight,
                          color: dividerColor,
                        ),
                        Expanded(
                          flex: widget.amountFlex,
                          child: _buildAmountField(field),
                        ),
                      ],
                    ),
            ),
            if (field.errorText != null) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  field.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
