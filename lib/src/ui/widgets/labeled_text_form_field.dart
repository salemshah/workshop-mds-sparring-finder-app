import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Define or import your `authOutlineInputBorder` here
final OutlineInputBorder authOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(50),
  borderSide: BorderSide(
    color: Colors.grey, // Default color, customize as needed
    width: 2.0,
    style: BorderStyle.solid,
  ),
);

class LabeledTextFormField extends StatelessWidget {
  /// The label text displayed above the TextFormField
  final String label;

  /// Controller to manage the text being edited
  final TextEditingController controller;

  /// Validator function for input validation
  final String? Function(String?)? validator;

  /// Hint text displayed inside the TextFormField
  final String hintText;

  /// Action button on the keyboard (e.g., next, done)
  final TextInputAction textInputAction;

  /// Determines whether to obscure the text (useful for passwords)
  final bool obscureText;

  /// Enables or disables suggestions
  final bool enableSuggestions;

  /// Enables or disables autocorrect
  final bool autocorrect;

  /// Additional decoration for the TextFormField (optional)
  final InputDecoration? decoration;

  const LabeledTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    required this.hintText,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w), // Responsive padding
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Sriracha',
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 22.sp, // Responsive font size
            ),
          ),
        ),
        SizedBox(height: 8.h), // Responsive spacing
        TextFormField(
          controller: controller,
          textInputAction: textInputAction,
          validator: validator,
          obscureText: obscureText,
          enableSuggestions: enableSuggestions,
          autocorrect: autocorrect,
          decoration: decoration ??
              InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 3.0,
                    style: BorderStyle.solid,
                  ),
                ),
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Sriracha',
                  fontSize: 17.sp,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: TextStyle(
                  color: const Color(0xFF757575),
                  fontFamily: 'Sriracha',
                  fontSize: 15.sp,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                border: authOutlineInputBorder,
                enabledBorder: authOutlineInputBorder,
                focusedBorder: authOutlineInputBorder.copyWith(
                  borderSide: const BorderSide(
                    color: Color(0xFFF344FF),
                    width: 3,
                  ),
                ),
              ),
        ),
      ],
    );
  }
}
