import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class HomeHeaderSkeleton extends StatelessWidget {
  const HomeHeaderSkeleton({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Shimmer.fromColors(
        baseColor: AppColors.inputFill,
        highlightColor: AppColors.text.withValues(alpha: 0.2),
        period: const Duration(milliseconds: 1300),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Row(
                children: [
                  _placeholderBox(height: 70.r, width: 70.r, radius: 35),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _placeholderBox(height: 10.h, width: 60.w),
                      SizedBox(height: 10.h),
                      _placeholderBox(height: 20.h, width: 60.w),
                    ],
                  ),
                  Spacer(),
                  _placeholderBox(height: 40.h, width: 40.w),
                ],
              ),
              SizedBox(height: 10.h),
              _placeholderBox(height: 10.h, width: 200.w),
              SizedBox(height: 10.h),
              _placeholderBox(height: 10.h, width: 270.w),
              SizedBox(height: 20.h),
              _placeholderBox(height: 35.h, radius: 100),
              SizedBox(height: 20.h),
              Row(
                children: [
                  _placeholderBox(height: 15.h, width: 80.w),
                  Spacer(),
                  _placeholderBox(height: 15.h, width: 80.w),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
