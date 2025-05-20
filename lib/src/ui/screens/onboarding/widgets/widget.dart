import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/Global.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/constants/app_contants.dart';
import 'package:sparring_finder/src/ui/screens/onboarding/widgets/text.dart';

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
          // Image with animation
          _buildImageSection(context),
          
          SizedBox(height: 40.h),
          
          // Content card
          _buildContentCard(context),
          
          SizedBox(height: 40.h),
          
          // Button
          _buildButton(context),
        ],
      ),
    );
  }
  
  Widget _buildImageSection(BuildContext context) {
    return Hero(
      tag: 'onboarding-image-$index',
      child: Container(
        height: 280.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildContentCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          FadeInText(
            title,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Sriracha',
            ),
          ),
          SizedBox(height: 16.h),
          FadeInText(
            subTitle,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white.withOpacity(0.8),
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
        width: 325.w,
        height: 60.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kRed, kRed.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: kRed.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              index < 3 ? "Suivant" : "Commencer",
              style: TextStyle(
                fontSize: 20.sp,
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
