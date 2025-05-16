import 'package:flutter/material.dart';

class FontSize {
  // Constructor
  FontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1440) {
      // Large Desktop
      _fontSizeMultiplier = 1.8;
    } else if (screenWidth >= 1200) {
      // Small Desktop
      _fontSizeMultiplier = 1.5;
    } else if (screenWidth >= 1024) {
      // Tablet
      _fontSizeMultiplier = 1.3;
    } else if (screenWidth >= 768) {
      // Mobile
      _fontSizeMultiplier = 1.1;
    } else if (screenWidth >= 600) {
      // Small Mobile
      _fontSizeMultiplier = 0.95;
    } else {
      // Extra Extra Small Mobile
      _fontSizeMultiplier = 0.75;
    }
  }

  // A multiplier for font size based on screen size
  late double _fontSizeMultiplier;

  // Font sizes
  double get small => 12 * _fontSizeMultiplier;

  double get body => 14 * _fontSizeMultiplier;

  double get caption => 16 * _fontSizeMultiplier;

  double get subtitle => 18 * _fontSizeMultiplier;

  double get title => 22 * _fontSizeMultiplier;

  double get largeTitle => 26 * _fontSizeMultiplier;

  double get extraLarge => 32 * _fontSizeMultiplier;

  double get headline => 40 * _fontSizeMultiplier;

  TextStyle get titleStyle =>
      TextStyle(fontSize: title, fontWeight: FontWeight.bold);

  TextStyle get subtitleStyle =>
      TextStyle(fontSize: subtitle, fontWeight: FontWeight.w500);

  TextStyle get bodyStyle =>
      TextStyle(fontSize: body, fontWeight: FontWeight.normal);

  TextStyle get captionStyle =>
      TextStyle(fontSize: caption, fontWeight: FontWeight.w300);

  TextStyle get smallStyle =>
      TextStyle(fontSize: small, fontWeight: FontWeight.normal);

  TextStyle get largeTitleStyle =>
      TextStyle(fontSize: largeTitle, fontWeight: FontWeight.bold);

  TextStyle get headlineStyle =>
      TextStyle(fontSize: headline, fontWeight: FontWeight.bold);
}
