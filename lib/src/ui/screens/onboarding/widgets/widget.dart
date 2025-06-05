import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/utils/secure_storage_helper.dart';

import '../../../../utils/jwt.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 24),
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
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
           Text(
              title,
              style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
                                    
          SizedBox(height: 8),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),),
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
          final navigator = Navigator.of(context);
          await SecureStorageHelper.markOnboardingSeen();
          final isLoggedIn = !(await JwtStorageHelper.isTokenExpired());

          final targetRoute = isLoggedIn
              ? AppRoutes.applicationScreen
              : AppRoutes.loginScreen;

          navigator.pushNamedAndRemoveUntil(targetRoute, (route) => false);
        }
      },
      child: Container(
        width: width / 2,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              index < 3 ? "Next" : "Get Started",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              index < 3 ? Icons.arrow_forward : Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
