import 'package:flutter/material.dart';

class InputDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hintText;

  const InputDatePicker({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    this.controller,
    this.validator,
    this.hintText = "Select Date",
  });

  @override
  _InputDatePickerState createState() => _InputDatePickerState();
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
      // You can change the format as needed.
      _controller.text =
          "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
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
    return TextFormField(
      controller: _controller,
      readOnly: true,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(Icons.calendar_today),
        enabledBorder: OutlineInputBorder( // Border when the field is not focused
          borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2.0),
          borderRadius: BorderRadius.circular(14.0),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.0)),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _pickDate();
      },
    );
  }

  @override
  void dispose() {
    // Only dispose the controller if it was created internally.
    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }
}
