import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/constants/app_contants.dart';

import 'dart:ui';
import 'dart:math' as math;

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

  // Animation values for the pulsating effect
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  
  // Animation for loading indicator
  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // Fade animation setup
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );
    
    // Rotate animation setup
    _rotateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _rotateAnimationController, curve: Curves.easeInOut),
    );
    
    // Scale animation setup
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.elasticOut),
    );
    
    // Slide animation setup
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideAnimationController, curve: Curves.easeOutCubic),
    );
    
    // Pulse animation setup
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseAnimationController, curve: Curves.easeInOut),
    );
    
    // Loading animation setup
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingAnimationController, curve: Curves.linear),
    );
    
    // Start animations
    _fadeAnimationController.forward();
    _rotateAnimationController.forward();
    _scaleAnimationController.forward();
    _slideAnimationController.forward();
    
    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () async {
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main logo/image
                _buildMainImage(),
                
                SizedBox(height: 40.h),
                
                // App name
                _buildAppName(),
                
                SizedBox(height: 40.h),
                
                // Loading indicator
                _buildLoadingIndicator(),
                
                SizedBox(height: 15.h),
                
                // Loading text
                _buildLoadingText(),
              ],
            ),
          ),
          
          // Decorative elements
          _buildDecorativeElements(),
        ],
      ),
    );
  }
  
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _rotateAnimationController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1E23),
                Color(0xFF23272E),
                Color(0xFF282F35),
              ],
              transform: GradientRotation(_rotateAnimation.value * math.pi),
            ),
          ),
          child: Stack(
            children: [
              // Gradient overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: GradientOverlayPainter(
                    animation: _pulseAnimation.value,
                    color: kRed.withOpacity(0.15),
                  ),
                ),
              ),
              
              // Blurred circles for modern look
              Positioned(
                top: -100.h,
                right: -50.w,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 200.w * _pulseAnimation.value,
                      height: 200.w * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kRed.withOpacity(0.2),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              Positioned(
                bottom: -80.h,
                left: -30.w,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 150.w * _pulseAnimation.value,
                      height: 150.w * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kLightBlue.withOpacity(0.15),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMainImage() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 280.w,
          height: 280.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: kRed.withOpacity(0.3),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/boxer.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAppName() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "SPARRING",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "FINDER",
              style: TextStyle(
                color: kRed,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingIndicator() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _loadingAnimation,
        builder: (context, child) {
          return SizedBox(
            width: 50.w,
            height: 50.w,
            child: CustomPaint(
              painter: LoadingIndicatorPainter(
                animation: _loadingAnimation.value,
                color: kRed,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLoadingText() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        "Chargement en cours...",
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
    );
  }
  
  Widget _buildDecorativeElements() {
    return Stack(
      children: [
        // Add any additional decorative elements here
        Positioned(
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
        ),
      ],
    );
  }
}

// Custom painter for gradient overlay
class GradientOverlayPainter extends CustomPainter {
  final double animation;
  final Color color;
  
  GradientOverlayPainter({required this.animation, required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color,
          color.withOpacity(0),
        ],
        stops: [0.0, 0.7],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width * animation,
      ));
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(GradientOverlayPainter oldDelegate) {
    return animation != oldDelegate.animation || color != oldDelegate.color;
  }
}

// Custom painter for loading indicator
class LoadingIndicatorPainter extends CustomPainter {
  final double animation;
  final Color color;
  
  LoadingIndicatorPainter({required this.animation, required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Background circle
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    
    canvas.drawCircle(center, radius, bgPaint);
    
    // Animated arc
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
  bool shouldRepaint(LoadingIndicatorPainter oldDelegate) {
    return animation != oldDelegate.animation || color != oldDelegate.color;
  }
}
