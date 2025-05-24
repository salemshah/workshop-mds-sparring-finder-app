import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(AppTheme.spacingL),
            margin: EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppColors.inputFill.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingL),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppTheme.spacingL),
                Text(
                  title,
                  style: AppTheme.headingMedium,
                ),
                SizedBox(height: AppTheme.spacingM),
                Text(
                  "Coming soon",
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.label,
                  ),
                ),
                SizedBox(height: AppTheme.spacingXL),
                ElevatedButton(
                  style: AppTheme.primaryButton,
                  onPressed: () {},
                  child: const Text("Get notified when available"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
