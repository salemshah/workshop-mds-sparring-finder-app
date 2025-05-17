import 'package:flutter/material.dart';
import 'package:sparring_finder/src/ui/screens/profile/create_profile_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/forgot_password_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/reset_password_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_register_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_login_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_email_verification_screen.dart';
import 'package:sparring_finder/src/ui/screens/home/home_screen.dart';

class AppRoutes {
  static const String registerScreen = '/register';
  static const String loginScreen = '/login';
  static const String verifyEmailScreen = '/verify-email';
  static const String homeScreen = '/home';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String resetPasswordScreen = '/reset-password';
  static const String createProfileScreen = '/create-profile';

  static Map<String, WidgetBuilder> routes = {
    registerScreen: (_) => const RegisterScreen(),
    loginScreen: (_) => const LoginScreen(),
    verifyEmailScreen: (_) => const VerifyEmailScreen(),
    homeScreen: (_) => const HomeScreen(),
    forgotPasswordScreen: (_) => const ForgotPasswordScreen(),
    resetPasswordScreen: (_) => const ResetPasswordScreen(),
    createProfileScreen: (_) => const CreateProfileScreen(),
  };
}
