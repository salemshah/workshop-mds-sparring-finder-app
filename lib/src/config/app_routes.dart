import 'package:flutter/material.dart';
import 'package:sparring_finder/src/models/profile/profile_model.dart';
import 'package:sparring_finder/src/ui/common/loading_screeen.dart';
import 'package:sparring_finder/src/ui/screens/availability/availability_form_screen.dart';
import 'package:sparring_finder/src/ui/screens/home/athlete_details_screen.dart';
import 'package:sparring_finder/src/ui/screens/message/chat_lits_screen.dart';
import 'package:sparring_finder/src/ui/screens/message/chat_screen.dart';
import 'package:sparring_finder/src/ui/screens/notification/notification_screen.dart';
import 'package:sparring_finder/src/ui/screens/profile/create_profile_screen.dart';
import 'package:sparring_finder/src/ui/screens/home/athlete_availabilities_calender_screen.dart';
import 'package:sparring_finder/src/ui/screens/test/address_picker_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/forgot_password_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/reset_password_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_register_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_login_screen.dart';
import 'package:sparring_finder/src/ui/screens/user/user_email_verification_screen.dart';
import 'package:sparring_finder/src/ui/screens/home/home_screen.dart';

import '../models/availability/availability_model.dart';
import '../ui/screens/application/application.dart';
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
  static const String notificationScreen = '/notification-screen';

  static const String splashScreen = '/splash-screen';
  static const String settingsScreen = '/settings';
  static const String onBoardingScreen = '/onboarding';
  static const String profileScreen = '/profile';
  static const String applicationScreen = '/application';
  static const String availabilityListScreen = '/availability-list';
  static const String athleteAvailabilitiesCalenderScreen =
      '/athlete-availabilities-calender-screen';
  static const String athletesMapScreen = 'athletes-map-screen';
  static const String addressPickerScreen = 'address-picker-screen';
  static const String chatListScreen = 'chat-list-screen';
  static const String chatScreen = 'chat-screen';
  static const String testForm = 'test-form-screen';

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
    notificationScreen: (_) => const NotificationScreen(),
    addressPickerScreen: (_) => const AddressPickerScreen(),
    chatListScreen: (_) => const ChatListScreen(),
    // chatScreen: (_) => const ChatScreen(),

    // Sparring Sessions screens
    sparringSessionScreen: (_) => const SparringSessionScreen(),

    splashScreen: (_) => const SplashScreen(),
    settingsScreen: (_) => const SettingScreen(),
    onBoardingScreen: (_) => const OnBoardingScreen(),
    profileScreen: (_) => const ProfileScreen(),
    applicationScreen: (_) => const ApplicationScreen(),
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case chatListScreen:
        return MaterialPageRoute(builder: (_) => const ChatListScreen());
      case chatScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: args['conversationId'] as int,
            conversationName: args['conversationName'] as String,
          ),
        );
      case athleteAvailabilitiesCalenderScreen:
        final targetUserId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) =>
              AthleteAvailabilitiesCalenderScreen(targetUserId: targetUserId),
        );

      case availabilityFormScreen:
        final availability = settings.arguments as Availability?;
        return MaterialPageRoute(
          builder: (_) => AvailabilityFormScreen(availability: availability),
        );

      case athleteDetailsScreen:
        final profile = settings.arguments as Profile;
        return MaterialPageRoute(
          builder: (_) => AthleteDetailsScreen(profile: profile),
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
