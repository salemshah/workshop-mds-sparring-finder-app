import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InputDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final String hint;

  const InputDatePicker({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    this.controller,
    this.validator,
    this.label = "Date",
    this.hint = "Select Date",
  });

  @override
  State<InputDatePicker> createState() => _InputDatePickerState();
}

class _InputDatePickerState extends State<InputDatePicker> {
  late TextEditingController _controller;
  late bool _isExternalController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? TextEditingController();
    _selectedDate = widget.initialDate;
    _updateController();
  }

  void _updateController() {
    if (_selectedDate != null) {
      _controller.text =
      "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
    }
  }

  Future<void> _pickDate() async {
    DateTime initialDate =
        _selectedDate ?? widget.initialDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateController();
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _controller,
          readOnly: true,
          validator: widget.validator,
          style: const TextStyle(color: AppColors.text),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _pickDate();
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.hint),
            filled: true,
            fillColor: AppColors.inputFill,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: const Icon(Icons.calendar_today, color: AppColors.hint),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColors.border, width: 3),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColors.border, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColors.primary, width: 3),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red, width: 3),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.redAccent, width: 3),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }
}
