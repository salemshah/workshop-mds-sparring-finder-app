
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_bloc.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_event.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_state.dart';
import 'package:sparring_finder/src/constants/app_contants.dart';
import 'package:sparring_finder/src/ui/screens/onboarding/widgets/widget.dart';
import 'package:sparring_finder/src/utils/image_res.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with SingleTickerProviderStateMixin {
  final PageController pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _backgroundAnimation;
  
  final List<Map<String, String>> onboardingData = [
    {
      'imagePath': ImageRes.onboarding,
      'title': 'Bienvenue!',
      'subTitle': 'Apprenez la boxe et améliorez vos compétences',
    },
    {
      'imagePath': 'assets/images/boxer.png',
      'title': 'Trouvez un Partenaire!',
      'subTitle': 'Rencontrez d\'autres boxeurs pour l\'entraînement et le sparring',
    },
    {
      'imagePath': ImageRes.onboarding,
      'title': 'Réservez une Session!',
      'subTitle': 'Planifiez facilement des sessions de sparring et d\'entraînement',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OnBoardBloc, OnBoardState>(
        builder: (context, state) {
          final isLastPage = state is OnBoardLastPageState && state.isLastPage;

          return Stack(
            children: [
              // Animated background
              AnimatedBuilder(
                animation: _backgroundAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryBackground,
                          Color.lerp(primaryBackground, kRed.withOpacity(0.7), _backgroundAnimation.value)!,
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              // Content
              SafeArea(
                child: Column(
                  children: [
                    // Skip button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16.h, right: 16.w),
                        child: isLastPage 
                          ? const SizedBox.shrink()
                          : TextButton(
                              onPressed: () {
                                pageController.animateToPage(
                                  2,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                'Passer',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                      ),
                    ),
                    
                    // Page view
                    Expanded(
                      child: PageView.builder(
                        physics: isLastPage
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        controller: pageController,
                        onPageChanged: (page) {
                          context
                              .read<OnBoardBloc>()
                              .add(OnBoardLastPageChanged(isLastPage: page == 2));
                          
                          // Animate background on page change
                          _animationController.reset();
                          _animationController.forward();
                        },
                        itemCount: onboardingData.length,
                        itemBuilder: (context, index) {
                          return AppOnboardingPage(
                            controller: pageController,
                            imagePath: onboardingData[index]['imagePath']!,
                            title: onboardingData[index]['title']!,
                            subTitle: onboardingData[index]['subTitle']!,
                            index: index + 1,
                          );
                        },
                      ),
                    ),
                    
                    // Page indicator
                    Padding(
                      padding: EdgeInsets.only(bottom: 32.h),
                      child: isLastPage
                          ? const SizedBox.shrink()
                          : SmoothPageIndicator(
                              controller: pageController,
                              count: 3,
                              effect: ExpandingDotsEffect(
                                dotHeight: 10.h,
                                dotWidth: 10.w,
                                spacing: 8.w,
                                expansionFactor: 3,
                                dotColor: Colors.white30,
                                activeDotColor: kRed,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
