import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonSize {
  ButtonSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1440) {
      // Large Desktop
      _width = 1.8;
      _height = 1.8;
    } else if (screenWidth >= 1200) {
      // Small Desktop
      _width = 1.5;
    } else if (screenWidth >= 1024) {
      // Tablet
      _width = 1.3;
    } else if (screenWidth >= 768) {
      // Mobile
      _width = 1.1;
    } else if (screenWidth >= 600) {
      // Small Mobile
      _width = 0.95;
    } else {
      // Extra Extra Small Mobile
      _width = 0.75;
    }
  }

  late double _width;
  late double _height;

  Widget smallButton(context, onPressed, title) => SizedBox(
        width: _width.w,
        height: _height.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget mediumButton(context, onPressed, title) => SizedBox(
        width: _width.w,
        height: _height.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget largeButton(context, onPressed, title) => SizedBox(
    width: _width.w,
    height: _height.h,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
