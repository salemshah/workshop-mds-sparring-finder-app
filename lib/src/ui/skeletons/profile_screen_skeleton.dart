import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  Widget _buildLine({double width = double.infinity, double height = 12}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.inputFill,
      highlightColor: AppColors.text,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(radius: 55.w, backgroundColor: Colors.white),
            SizedBox(height: 16.h),

            // Name
            _buildLine(width: 150.w, height: 18.h),

            // Location
            _buildLine(width: 100.w, height: 14.h),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  2,
                  (_) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.all(6),
                          height: 30.h,
                        ),
                      )),
            ),

            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  1,
                  (_) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: AppColors.inputFill,
                          ),
                          // margin: const EdgeInsets.all(6),
                          height: 80.h,
                        ),
                      )),
            ),

            // Bio
            SizedBox(height: 16.h),
            _buildLine(width: double.infinity),
            _buildLine(width: double.infinity),
            _buildLine(width: 100.w),

            // Info Rows
            SizedBox(height: 10.h),
            ...List.generate(
              15,
              (_) => Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.inputFill, width: 2)),
                ),
                height: 35.h,
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.inputFill),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildLine(width: double.infinity)
                    ),
                    Expanded(child: SizedBox()),
                    Expanded(
                      child: _buildLine(width: double.infinity)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
