import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TextWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final double iconSize;
  final double fontSize;
  final Color iconColor;
  final TextStyle? textStyle;
  final double spacing;

  const TextWithIcon({
    super.key,
    required this.icon,
    required this.text,
    this.iconSize = 20.0,
    this.iconColor = Colors.white,
    this.textStyle,
    this.spacing = 4.0,
    this.fontSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(width: spacing),
        Text(
          text,
          style: textStyle ??
              TextStyle(
                color: AppColors.text,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
