import 'package:flutter/material.dart';
import 'package:apuntes/widgets/widgets.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.label,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.color,
    this.initialValue,
    this.errorMessage,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.controller,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
  });

  final String? label;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Color? color;
  final String? initialValue;
  final String? errorMessage;
  final void Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.transparent));

    return CustomContainer(
      borderVariant: BorderVariant.all,
      color: color,
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        keyboardType: keyboardType,
        initialValue: initialValue,
        maxLines: maxLines,
        maxLength: maxLength,
        autofocus: autofocus,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            errorText: errorMessage,
            border: border,
            focusedErrorBorder: border,
            errorMaxLines: 2,
            enabledBorder: border,
            focusedBorder: border,
            isDense: true,
            focusColor: colors.primary,
            label: (label == null) ? null : Text(label!),
            hintText: hintText,
            suffixIcon: suffixIcon,
            floatingLabelStyle: const TextStyle(
              // color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
      ),
    );
  }
}
