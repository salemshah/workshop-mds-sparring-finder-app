import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_event.dart';
import 'package:sparring_finder/src/blocs/profile/profile_state.dart';
import 'package:sparring_finder/src/blocs/notification/notification_bloc.dart';
import 'package:sparring_finder/src/blocs/notification/notification_event.dart';
import 'package:sparring_finder/src/utils/secure_storage_helper.dart';

import 'dart:ui';
import 'dart:math' as math;

import '../../../utils/install_helper.dart';
import '../../../utils/jwt.dart';
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
        vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _fadeAnimationController, curve: Curves.easeOut));

    _rotateAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
        CurvedAnimation(
            parent: _rotateAnimationController, curve: Curves.easeInOut));

    _scaleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
            parent: _scaleAnimationController, curve: Curves.elasticOut));

    _slideAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _slideAnimationController, curve: Curves.easeOutCubic));

    _pulseAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
            parent: _pulseAnimationController, curve: Curves.easeInOut));

    _loadingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _loadingAnimationController, curve: Curves.linear));

    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _colorShiftAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _colorAnimationController, curve: Curves.linear));

    _fadeAnimationController.forward();
    _rotateAnimationController.forward();
    _scaleAnimationController.forward();
    _slideAnimationController.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      await InstallHelper.handleFreshInstall();
      final hasSeenOnboarding = await SecureStorageHelper.hasSeenOnboarding();
      if (!mounted) return;

      if (!hasSeenOnboarding) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.onBoardingScreen,
          (route) => false,
        );
        return;
      }

      final token = await JwtStorageHelper.getAccessToken();
      final isInvalid =
          token == null || await JwtStorageHelper.isTokenExpired();

      if (isInvalid) {
        await JwtStorageHelper.clearTokens();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.loginScreen,
          (route) => false,
        );
        return;
      }

      if (!mounted) return;
      context.read<NotificationBloc>().add(const NotificationStarted());

      context.read<MyProfileBloc>().add(const MyProfileExistenceChecked());

      await for (final state in context.read<MyProfileBloc>().stream) {
        if (!mounted) return;

        if (state is MyProfileExistenceSuccess) {
          if (state.isProfileExist) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.applicationScreen,
              (route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.createProfileScreen,
              (route) => false,
            );
          }
          break;
        } else if (state is MyProfileFailure) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.loginScreen,
            (route) => false,
          );
          break;
        }
      }
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAppName(),
              ],
            ),
          ),
          _buildDecorativeElements(),
        ],
      ),
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
              AppColors.white
            ];
            final shader = LinearGradient(
              colors: colors,
              stops: [0.0, 0.5, 0.7, 1.0],
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
              transform:
                  GradientRotation(_colorShiftAnimation.value * 2 * math.pi),
            ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0));

            return Column(
              children: [
                Stack(
                  children: [
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
            color: Colors.white.withAlpha(100),
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
