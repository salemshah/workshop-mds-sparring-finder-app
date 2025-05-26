import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class HomeAthleteSkeleton extends StatelessWidget {
  const HomeAthleteSkeleton({super.key});

  Widget _placeholderBox(
      {double? height, double? width, double radius = 6, EdgeInsets? margin}) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }

  Widget _buildProfileCardSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.inputFill.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // Circular avatar
            _placeholderBox(height: 45.w, width: 45.w, radius: 45),
            SizedBox(width: 12.w),

            // Name and info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _placeholderBox(
                    height: 14.h,
                    width: 120.w,
                    radius: 4,
                    margin: EdgeInsets.only(bottom: 8.h),
                  ),
                  Row(
                    children: List.generate(
                        4,
                        (_) => _placeholderBox(
                              height: 10.h,
                              width: 40.w,
                              radius: 4,
                              margin: EdgeInsets.only(right: 8.w),
                            )),
                  ),
                ],
              ),
            ),

            // Heart icon placeholder
            _placeholderBox(height: 24.w, width: 24.w, radius: 24),
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
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 15.h),
            ...List.generate(8, (_) => _buildProfileCardSkeleton()),
          ],
        ),
      ),
    );
  }
}
