import 'package:flutter/material.dart';
import 'package:moviflix/utils/my_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.autofocus,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType,
    this.obscureText,
    this.fontSize,
  });

  final TextEditingController controller;
  final String labelText;
  final bool? autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final bool? obscureText;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      autofocus: autofocus ?? false,
      decoration: InputDecoration(
        focusColor: MyColors.greyLight,
        labelText: labelText,
        labelStyle: TextStyle(fontSize: fontSize),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      keyboardType: textInputType,
    );
  }
}
