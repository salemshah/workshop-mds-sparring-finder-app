import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class ChatListSkeletonScreen extends StatelessWidget {
  const ChatListSkeletonScreen({super.key});

  Widget _placeholderBox({
    double? height,
    double? width,
    double radius = 6,
    EdgeInsets? margin,
  }) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(radius.r),
          border: Border(bottom: BorderSide(color: AppColors.text))),
    );
  }

  Widget _buildChatItemSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular avatar
          _placeholderBox(
            height: 46.w,
            width: 46.w,
            radius: 23,
          ),
          SizedBox(width: 12.w),

          // Name and last message
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
                _placeholderBox(
                  height: 12.h,
                  width: 180.w,
                  radius: 4,
                ),
              ],
            ),
          ),

          // Time placeholder
          _placeholderBox(
            height: 30.h,
            width: 30.w,
            radius: 4,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.background,
      highlightColor: AppColors.inputFill,
      period: const Duration(milliseconds: 1300),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(8, (_) => _buildChatItemSkeleton()),
        ),
      ),
    );
  }
}
