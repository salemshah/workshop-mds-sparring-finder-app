import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  /// Called whenever the selected index changes (0 or 1).
  final ValueChanged<int>? onChanged;

  /// The initially selected index: 0 (left) or 1 (right). Defaults to 0.
  final int initialIndex;

  const CustomToggleSwitch({
    super.key,
    this.onChanged,
    this.initialIndex = 0,
  }) : assert(initialIndex == 0 || initialIndex == 1);

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Initialize from widget.initialIndex
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant CustomToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent changed initialIndex, update our internal state too.
    if (widget.initialIndex != oldWidget.initialIndex) {
      _selectedIndex = widget.initialIndex;
    }
  }

  void _onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    // Dimensions you can tweak:
    const double totalWidth = 120;
    const double totalHeight = 30;
    const double borderRadius = 12;
    const Color borderColor = Color(0xFF858A90); // gray‐ish border
    const Color activeColor = Color(0xFFC0392B); // your “red” color
    const Color backgroundColor = Color(0xFF212529); // dark background behind

    return Container(
      width: totalWidth,
      height: totalHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // LEFT BUTTON
          Expanded(
            child: GestureDetector(
              onTap: () => _onTap(0),
              child: Container(
                decoration: BoxDecoration(
                  color:
                  (_selectedIndex == 0) ? activeColor : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(borderRadius - 2),
                    bottomLeft: Radius.circular(borderRadius - 2),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.format_list_bulleted, // bullet‐list icon
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // RIGHT BUTTON
          Expanded(
            child: GestureDetector(
              onTap: () => _onTap(1),
              child: Container(
                decoration: BoxDecoration(
                  color:
                  (_selectedIndex == 1) ? activeColor : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(borderRadius - 2),
                    bottomRight: Radius.circular(borderRadius - 2),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.map, // map icon
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
