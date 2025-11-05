import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../core/app_export.dart';

// ignore_for_file: must_be_immutable
class CustomPinCodeTextField extends StatelessWidget {
  CustomPinCodeTextField({
    Key? key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
  }) : super(key: key);

  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  Function(String) onChanged;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: pinCodeTextFieldWidget,
        )
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget => PinCodeTextField(
    appContext: context,
    controller: controller,
    length: 4,
    keyboardType: TextInputType.number,
    textStyle: textStyle ?? CustomTextStyles.titleLargeMontGray900,
    hintStyle: hintStyle ?? CustomTextStyles.titleLargeMontGray900,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    enableActiveFill: true,
    pinTheme: PinTheme(
      fieldHeight: 50.h,
      fieldWidth: 72.h,
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(8.h),
      inactiveColor: appTheme.green500,
      inactiveFillColor: appTheme.gray50,
      activeColor: appTheme.red700,
      activeFillColor: appTheme.gray50,
      selectedFillColor: appTheme.gray50,
      selectedColor: appTheme.red700,
    ),
    onChanged: (value) => onChanged(value),
    validator: validator,
  );
}
