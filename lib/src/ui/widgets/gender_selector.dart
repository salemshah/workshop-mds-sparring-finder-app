import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GenderSelector extends StatefulWidget {
  final void Function(String) onChanged;
  final String initial;

  const GenderSelector({
    super.key,
    required this.onChanged,
    this.initial = 'Male',
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String _selected = 'Male';
  final List<String> _options = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: _options.map((gender) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _selected == gender,
              onChanged: (value) {
                setState(() => _selected = gender);
                widget.onChanged(gender);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              activeColor: AppColors.primary,
              checkColor: Colors.white,
              side: const BorderSide(color: AppColors.border),
            ),
            Text(
              gender,
              style: const TextStyle(color: AppColors.text),
            ),
          ],
        );
      }).toList(),
    );
  }
}
