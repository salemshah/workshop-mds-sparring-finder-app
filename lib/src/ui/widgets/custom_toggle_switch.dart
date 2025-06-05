import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomToggleSwitch extends StatefulWidget {

  final ValueChanged<int>? onChanged;

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
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant CustomToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    // You can tweak these dimensions if needed:
    const double totalWidth = 130;
    const double totalHeight = 35; // slightly taller for better tap target
    const double borderRadius = 20;
    const Color borderColor = AppColors.border;      // gray‐ish border
    const Color activeColor = AppColors.primary;      // your “red” color
    const Color backgroundColor = Color(0xFF212529);  // dark background

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
      child: Stack(
        children: [
          // Animated “thumb” that slides left/right
          AnimatedAlign(
            alignment: _selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Container(
              width: totalWidth / 2,
              height: totalHeight,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(borderRadius - 1),
              ),
            ),
          ),

          // Two ripple‐enabled icons on top of the sliding thumb
          Row(
            children: [
              // LEFT BUTTON
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(borderRadius - 1)),
                    onTap: () => _onTap(0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.format_list_bulleted,
                        size: 20,
                        color: Colors.white.withOpacity(
                          _selectedIndex == 0 ? 1.0 : 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // RIGHT BUTTON
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(borderRadius - 1)),
                    onTap: () => _onTap(1),
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.map,
                        size: 20,
                        color: Colors.white.withOpacity(
                          _selectedIndex == 1 ? 1.0 : 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
