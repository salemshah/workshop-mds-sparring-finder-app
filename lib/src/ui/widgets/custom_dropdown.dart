import 'package:flutter/material.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';

class CustomDropdown extends StatefulWidget {
  final TextEditingController controller;
  final List<String> levels;
  final String label;
  final String hint;
  final double borderWeight;
  final double height;

  const CustomDropdown({
    super.key,
    required this.controller,
    required this.levels,
    required this.label,
    required this.hint,
    this.borderWeight = 3,
    this.height = 60,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.controller.text.isNotEmpty ? widget.controller.text : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: AppColors.white, fontSize: 12),
        ),
        const SizedBox(height: 10),
        Container(
          height: widget.height,
          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.border, width: widget.borderWeight),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            dropdownColor: const Color(0xFF1C1E21),
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: const TextStyle(color: AppColors.white),
            hint: Text(
              widget.hint,
              style: const TextStyle(color: AppColors.text),
            ),
            items: widget.levels.map((String level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(level),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
                widget.controller.text = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}
