import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  /// Controller for managing dropdown value
  final T? value;

  /// List of items to display in dropdown
  final List<T> items;

  /// Callback for when item is selected
  final ValueChanged<T?>? onChanged;

  /// Label for the dropdown field
  final String hintText;

  /// Optional validator function
  final String? Function(T?)? validator;

  /// Icon for dropdown prefix
  final IconData? prefixIcon;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2.0),
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
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
