import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BioField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const BioField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      validator: validator,
      style: const TextStyle(color: AppColors.text),
      decoration: InputDecoration(
        hintText: 'Enter your bio',
        hintStyle: const TextStyle(color: AppColors.hint),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
