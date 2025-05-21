import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/constants/app_contants.dart';

import 'dart:ui';
import 'dart:math' as math;

import '../../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late AnimationController _rotateAnimationController;
  late AnimationController _scaleAnimationController;
  late AnimationController _slideAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingAnimation;

  late AnimationController _colorAnimationController;
  late Animation<double> _colorShiftAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _rotateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _rotateAnimationController, curve: Curves.easeInOut),
    );

    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.elasticOut),
    );

    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideAnimationController, curve: Curves.easeOutCubic),
    );

    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseAnimationController, curve: Curves.easeInOut),
    );

    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingAnimationController, curve: Curves.linear),
    );

    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _colorShiftAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _colorAnimationController, curve: Curves.linear),
    );

    _fadeAnimationController.forward();
    _rotateAnimationController.forward();
    _scaleAnimationController.forward();
    _slideAnimationController.forward();

    // Navigate after delay
    Future.delayed(const Duration(seconds: 5), () async {
      // bool isFirstTime = Global.storageService.getDeviceFirstOpen();
      Navigator.of(context).pushReplacementNamed(AppRoutes.onBoardingScreen);
      // if (isFirstTime) {
      //   Navigator.of(context).pushReplacementNamed(Routes.onBoardingScreen);
      // } else {
      //   bool isLoggedIn = Global.storageService.isLoggedIn();
      //   if (isLoggedIn) {
      //     Navigator.of(context).pushReplacementNamed(Routes.homeScreen);
      //   } else {
      //     Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
      //   }
      // }
    });
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _rotateAnimationController.dispose();
    _scaleAnimationController.dispose();
    _slideAnimationController.dispose();
    _pulseAnimationController.dispose();
    _loadingAnimationController.dispose();
    _colorAnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // _buildAnimatedBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _buildMainImage(),
                // SizedBox(height: 40.h),
                _buildAppName(),
                // SizedBox(height: 40.h),
                // _buildLoadingIndicator(),
                // SizedBox(height: 15.h),
                // _buildLoadingText(),
              ],
            ),
          ),
          _buildDecorativeElements(),
        ],
      ),
    );
  }


  Widget _buildBlurredCircle(Color color, double size) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: size * _pulseAnimation.value,
          height: size * _pulseAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _colorShiftAnimation,
          builder: (context, child) {
            final colors = [
              AppColors.primary,
              AppColors.white,
              AppColors.primary,
              AppColors.white,
            ];

            final shader = LinearGradient(
              colors: colors,
              stops: [0.0, 0.5, 0.7, 1.0],
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              transform: GradientRotation(_colorShiftAnimation.value * 2 * math.pi),
            ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0));

            return Column(
              children: [
                Stack(
                  children: [
                    // Outline
                    ShaderMask(
                      shaderCallback: (bounds) => shader,
                      child: Text(
                        "SPARRING",
                        style: GoogleFonts.rubikWetPaint(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 10
                            ..color = AppColors.inputFill,
                        ),
                      ),
                    ),
                    // Fill
                    ShaderMask(
                      shaderCallback: (bounds) => shader,
                      child: Text(
                        "SPARRING",
                        style: GoogleFonts.rubikWetPaint(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    // Outline
                    ShaderMask(
                      shaderCallback: (bounds) => shader,
                      child: Text(
                        "FINDER",
                        style: GoogleFonts.rubikWetPaint(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = AppColors.background,
                        ),
                      ),
                    ),
                    // Fill
                    ShaderMask(
                      shaderCallback: (bounds) => shader,
                      child: Text(
                        "FINDER",
                        style: GoogleFonts.rubikWetPaint(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return Positioned(
      bottom: 20.h,
      right: 20.w,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          "v1.0",
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}

// Painter classes remain the same as your original post...
class GradientOverlayPainter extends CustomPainter {
  final double animation;
  final Color color;

  GradientOverlayPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withOpacity(0)],
        stops: [0.0, 0.7],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width * animation,
      ));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant GradientOverlayPainter oldDelegate) {
    return animation != oldDelegate.animation || color != oldDelegate.color;
  }
}

class LoadingIndicatorPainter extends CustomPainter {
  final double animation;
  final Color color;

  LoadingIndicatorPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, bgPaint);

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    final arcRect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      arcRect,
      -math.pi / 2 + (animation * 2 * math.pi),
      math.pi / 2,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant LoadingIndicatorPainter oldDelegate) {
    return animation != oldDelegate.animation || color != oldDelegate.color;
  }
}
