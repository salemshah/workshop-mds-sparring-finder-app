import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/ui/screens/onboarding/widgets/text.dart';

import '../../../theme/app_colors.dart';

class AppOnboardingPage extends StatelessWidget {
  final PageController controller;
  final String imagePath;
  final String title;
  final String subTitle;
  final int index;

  const AppOnboardingPage({
    super.key,
    required this.controller,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImageSection(context),
          _buildContentCard(context),
          SizedBox(height: 20),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height / 3.5,
      width: double.infinity,
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: [
          FadeInText(
            title,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Sriracha',
            ),
          ),
          SizedBox(height: 8.h),
          FadeInText(
            subTitle,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.white,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        if (index < 3) {
          controller.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        } else {
          // Global.storageService
          //     .setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_KEY, true);
          Navigator.pushNamed(context, AppRoutes.loginScreen);
        }
      },
      child: Container(
        width: width / 2,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              index < 3 ? "Next" : "Start",
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              index < 3 ? Icons.arrow_forward : Icons.check_circle,
              color: Colors.white,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
