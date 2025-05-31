import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';

class CalendarScreenSkeleton extends StatelessWidget {
  const CalendarScreenSkeleton({super.key});

  static const _baseColor = AppColors.inputFill;

  // static const _highlightColor = Colors.grey["800"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: _baseColor,
          highlightColor: AppColors.inputFill.withValues(alpha: .3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1) Month header placeholder
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Container(
                  height: 30,
                  color: Colors.white,
                ),
              ),

              // 2) Day‐of‐week labels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (_) {
                    return Container(
                      width: 30,
                      height: 16,
                      color: Colors.white,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              // 3) Calendar grid (5 rows × 7 columns)
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 1.5,
                      crossAxisSpacing: 1.5,
                      childAspectRatio: .85,
                    ),
                    itemCount: 7 * 6, // show 6 weeks for safety
                    itemBuilder: (_, __) => Container(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      // 4) Selected date header
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      //   child: Container(
                      //     height: 20,
                      //     width: 80,
                      //     color: Colors.white,
                      //   ),
                      // ),

                      // 5) Placeholder for two “availability” cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            _buildCardPlaceholder(),
                            const SizedBox(height: 8),
                            _buildCardPlaceholder(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPlaceholder() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
