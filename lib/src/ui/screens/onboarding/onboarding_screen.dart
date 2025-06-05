
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_bloc.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_event.dart';
import 'package:sparring_finder/src/blocs/onboarding/onboarding_state.dart';
import 'package:sparring_finder/src/ui/screens/onboarding/widgets/widget.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import 'package:sparring_finder/src/utils/image_res.dart';


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> with SingleTickerProviderStateMixin {
  final PageController pageController = PageController();
  late AnimationController _animationController;

  final List<Map<String, String>> onboardingData = [
    {
      'imagePath': ImageRes.onboarding,
      'title': 'Welcome to Your\n Boxing Network!',
      'subTitle': 'Connect, train, and grow your skills  — wherever you are.',
    },
    {
      'imagePath': ImageRes.onboarding,
      'title': 'Find the Perfect Partner',
      'subTitle': 'Match with boxers near you based on level and goals.',
    },
    {
      'imagePath': ImageRes.onboarding,
      'title': 'Book and Train with Ease',
      'subTitle': 'Plan your sessions, set your schedule, and get reminders.',
    },
  ];


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
      backgroundColor: AppColors.background,
      body: BlocBuilder<OnBoardBloc, OnBoardState>(
        builder: (context, state) {
          final isLastPage = state is OnBoardLastPageState && state.isLastPage;
          return Stack(
            children: [
              // Content
              SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
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
                            'Skip',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        physics: isLastPage
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        controller: pageController,
                        onPageChanged: (page) {
                          context.read<OnBoardBloc>().add(
                              OnBoardLastPageChanged(isLastPage: page == 2));
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


                    Container(
                      padding: EdgeInsets.only(bottom: 20.h),
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
                          activeDotColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
