import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  /// Controller to manage the input text.
  final TextEditingController controller;

  /// Icon to display at the start of the field (e.g., Icons.person).
  final IconData? prefixIcon;

  /// Hint text shown when the field is empty.
  final String hintText;

  /// Whether to obscure the text (useful for passwords).
  final bool obscureText;

  /// Optional validator function for validating input.
  final String? Function(String?)? validator;

  /// Content padding inside the TextFormField.
  final EdgeInsets contentPadding;


  const CustomTextFormField({
    super.key,
    required this.controller,
    this.prefixIcon,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.contentPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        hintText: hintText,
        enabledBorder: OutlineInputBorder( // Border when the field is not focused
          borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2.0),
          borderRadius: BorderRadius.circular(14.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6959C3), width: 2.0),
          borderRadius: BorderRadius.circular(14.0),
        ),
        errorBorder: OutlineInputBorder( // Border when validation fails
          borderRadius: BorderRadius.circular(14.0),
        ),
        focusedErrorBorder: OutlineInputBorder( // Border when focused with an error
          borderRadius: BorderRadius.circular(14.0),
        ),
        contentPadding: contentPadding,
      ),
    );
  }

}
