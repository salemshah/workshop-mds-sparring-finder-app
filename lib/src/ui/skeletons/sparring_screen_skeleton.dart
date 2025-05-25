import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';

class SparringScreenSkeleton extends StatelessWidget {
  const SparringScreenSkeleton({super.key});

  Widget _placeholderBox({
    double? width,
    double? height,
    double radius = 6,
    EdgeInsets? margin,
    bool isCircle = false,
  }) {
    return Container(
      width: width,
      height: height ?? width,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(radius.r),
      ),
    );
  }

  Widget _fighter() {
    return Expanded(
      child: Column(
        children: [
          _placeholderBox(width: 55.w, isCircle: true),
          SizedBox(height: 8.h),
          _placeholderBox(width: 60.w, height: 10.h),
          SizedBox(height: 4.h),
          _placeholderBox(width: 50.w, height: 10.h),
        ],
      ),
    );
  }

  Widget _buildSparringCard() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputFill.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Column(
          children: [
            // Header Row (Date - Location - Time)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (_) => _placeholderBox(width: 80.w, height: 12.h, radius: 4)),
              ),
            ),

            Divider(color: AppColors.primary.withOpacity(0.4), thickness: 1),

            // Fighters Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  _fighter(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _placeholderBox(width: 30.w, height: 30.h),
                  ),
                  _fighter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.inputFill,
      highlightColor: AppColors.text.withValues(alpha: 0.2),
      period: const Duration(milliseconds: 1300),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: List.generate(3, (_) => _buildSparringCard()),
        ),
      ),
    );
  }
}
