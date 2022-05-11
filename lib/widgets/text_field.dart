import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final String hintText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  IconButton? suffix;
  CustomTextField({
    Key? key,
    required this.controller,
    this.obscure = false,
    required this.hintText,
    required this.keyboardType,
    this.validator,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boeder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffix,
        border: boeder,
        enabledBorder: boeder,
        focusedErrorBorder: boeder,
        hintText: hintText,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: keyboardType,
      obscureText: obscure,
    );
  }
}
