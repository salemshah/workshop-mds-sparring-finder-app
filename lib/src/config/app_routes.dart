import 'package:flutter/material.dart';
import 'package:sparring_finder/src/models/profile/profile_model.dart';
import 'package:sparring_finder/src/ui/common/loading_screeen.dart';
import 'package:sparring_finder/src/ui/screens/availability/availability_form_screen.dart';
import 'package:sparring_finder/src/ui/screens/home/athlete_screen.dart';
import 'package:sparring_finder/src/ui/screens/profile/create_profile_screen.dart';
import 'package:sparring_finder/src/ui/screens/availability/time_table_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/forgot_password_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/reset_password_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_register_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_login_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_email_verification_screen.dart';
import 'package:sparring_finder/src/ui/screens/home/home_screen.dart';

import '../models/availability/availability_model.dart';
import '../ui/screens/application/application.dart';
import '../ui/screens/availability/availability_list_screen.dart';
import '../ui/screens/onboarding/onboarding_screen.dart';
import '../ui/screens/profile/profile_screen.dart';
import '../ui/screens/session/sparring_session_screen.dart';
import '../ui/screens/settings/settings.dart';
import '../ui/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String registerScreen = '/register';
  static const String loginScreen = '/login';
  static const String verifyEmailScreen = '/verify-email';
  static const String homeScreen = '/home-screen';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String resetPasswordScreen = '/reset-password';
  static const String createProfileScreen = '/create-profile';
  static const String loadingScreen = '/loading-screen';
  static const String athleteDetailsScreen = '/athlete-details';
  static const String sparringSessionScreen = '/sparring-screen';
  static const String availabilityFormScreen = '/availability-form';

  static const String splashScreen = '/splash-screen';
  static const String settingsScreen = '/settings';
  static const String onBoardingScreen = '/onboarding';
  static const String profileScreen = '/profile';
  static const String applicationScreen = '/application';
  static const String availabilityListScreen = '/availability-list';
  static const String timeTableScreen = '/time-table';

  /// For routes that **don't require arguments**
  static final Map<String, WidgetBuilder> staticRoutes = {
    loadingScreen: (_) => const LoadingScreen(),
    registerScreen: (_) => const RegisterScreen(),
    loginScreen: (_) => const LoginScreen(),
    verifyEmailScreen: (_) => const VerifyEmailScreen(),
    homeScreen: (_) => const HomeScreen(),
    forgotPasswordScreen: (_) => const ForgotPasswordScreen(),
    resetPasswordScreen: (_) => const ResetPasswordScreen(),
    createProfileScreen: (_) => const CreateProfileScreen(),



    // Sparring Sessions screens
    sparringSessionScreen: (_) => const SparringSessionScreen(),

    splashScreen: (_) => const SplashScreen(),
    settingsScreen: (_) => const SettingScreen(),
    onBoardingScreen: (_) => const OnBoardingScreen(),
    profileScreen: (_) => const ProfileScreen(),
    applicationScreen: (_) => const ApplicationScreen(),


    // test routes
    timeTableScreen: (_) => const TimetableScreen(),

  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case availabilityListScreen:
        final targetUserId = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => AvailabilityListScreen(targetUserId: targetUserId),
        );

      case availabilityFormScreen:
        final availability = settings.arguments as Availability?;
        return MaterialPageRoute(
          builder: (_) => AvailabilityFormScreen(availability: availability),
        );

      case athleteDetailsScreen:
        final profile = settings.arguments as Profile;
        return MaterialPageRoute(
          builder: (_) => AthleteDetailsPage(profile: profile),
        );

      default:
        final builder = staticRoutes[settings.name];
        if (builder != null) return MaterialPageRoute(builder: builder);
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
