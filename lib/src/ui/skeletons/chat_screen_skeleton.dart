import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreenSkeleton extends StatelessWidget {
  const ChatScreenSkeleton({super.key});

  Widget _bubblePlaceholder({
    required bool isMe,
    double width = 180,
    double height = 40,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        padding: EdgeInsets.all(10.w),
        constraints: BoxConstraints(maxWidth: width.w),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isMe ? 16.r : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16.r),
          ),
        ),
        height: height.h,
        width: width.w,
      ),
    );
  }

  Widget _buildChatBubbles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(10, (index) {
        bool isMe = index % 3 == 0; // Alternate messages
        return _bubblePlaceholder(
          isMe: isMe,
          width: (index % 4 + 2) * 40, // Vary width a bit
          height: 35 + (index % 2 * 10), // Vary height a bit
        );
      }),
    );
  }

  Widget _buildInputBarPlaceholder() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42.h,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            height: 42.h,
            width: 42.h,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      period: const Duration(milliseconds: 1200),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 12.h, bottom: 20.h),
              child: _buildChatBubbles(),
            ),
          ),
          _buildInputBarPlaceholder(),
        ],
      ),
    );
  }
}
