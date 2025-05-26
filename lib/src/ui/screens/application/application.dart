import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sparring_finder/src/ui/screens/availability/availability_calender_screen.dart';
import 'package:sparring_finder/src/ui/screens/session/sparring_session_screen.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_event.dart';
import '../../../config/app_routes.dart';
import '../../common/placeholder_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_navi_bar.dart';
import '../home/home_screen.dart';
import '../profile/profile.dart';

/// Main entry screen with bottom navigation and Firebase message listener.
/// Navigates based on tab selection and notification data.
class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SparringSessionScreen(),
    // PlaceholderScreen(title: "Sparring", icon: Icons.flash_on),
    PlaceholderScreen(title: "Messages", icon: Icons.message),
    // TimetableScreen(),
    // AvailabilityListScreen(),
    AvailabilityCalendarScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();

    // ✅ Listen for foreground FCM notifications
    FirebaseMessaging.onMessage.listen(_handleIncomingFCM);
  }

  /// Request push notification permission on iOS
  void _requestNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (kDebugMode) {
      print('Notification permission application.dart: ${settings.authorizationStatus}');
    }
  }

  /// Handle FCM message when app is in foreground
  void _handleIncomingFCM(RemoteMessage message) {
    if (kDebugMode) {
      print("Foreground FCM received application.dart");
      print("Title: ${message.notification?.title}");
      print("Data: ${message.data}");
    }

    final data = message.data;


    context.read<NotificationBloc>().add(NotificationReceived(
      title: message.notification?.title,
      body: message.notification?.body,
    ));

    // 🚦 Handle specific data types
    if (data['type'] == 'sparring-confirmed') {
      final sparringId = data['sparringId'];
      if (sparringId != null) {
        Navigator.pushNamed(context, AppRoutes.sparringSessionScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      body: Stack(
        children: [
          const _BackgroundGradient(),
          AnimatedSwitcher(
            duration: AppTheme.mediumAnimation,
            transitionBuilder: _transitionBuilder,
            child: KeyedSubtree(
              key: ValueKey<int>(_currentIndex),
              child: _screens[_currentIndex],
            ),
          ),
        ],
      ),
    );
  }

  /// Animates screen transitions
  Widget _transitionBuilder(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      ),
    );
  }
}

/// Gradient background
class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withOpacity(0.8),
          ],
        ),
      ),
    );
  }
}




// =============== Alive widgets inside navigation bar

// import 'package:flutter/material.dart';
// import '../../theme/app_colors.dart';
// import '../../widgets/bottom_navi_bar.dart';
// import '../home/home_screen.dart';
// import '../profile/profile.dart';
// import '../../common/placeholder_screen.dart';
//
// class ApplicationScreen extends StatefulWidget {
//   const ApplicationScreen({super.key});
//
//   @override
//   State<ApplicationScreen> createState() => _ApplicationScreenState();
// }
//
// class _ApplicationScreenState extends State<ApplicationScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     HomeScreen(),
//     PlaceholderScreen(title: "Sparring", icon: Icons.flash_on),
//     PlaceholderScreen(title: "Messages", icon: Icons.message),
//     PlaceholderScreen(title: "Favorites", icon: Icons.favorite),
//     ProfileScreen(),
//   ];
//
//   void _onTabTapped(int index) => setState(() => _currentIndex = index);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       extendBody: true,
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//       ),
//       body: Stack(
//         children: [
//           const _BackgroundGradient(),
//           IndexedStack(
//             index: _currentIndex,
//             children: _screens,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _transitionBuilder(Widget child, Animation<double> animation) {
//     return FadeTransition(
//       opacity: animation,
//       child: SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(0.05, 0),
//           end: Offset.zero,
//         ).animate(CurvedAnimation(
//           parent: animation,
//           curve: Curves.easeOutCubic,
//         )),
//         child: child,
//       ),
//     );
//   }
// }
//
// class _BackgroundGradient extends StatelessWidget {
//   const _BackgroundGradient();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             AppColors.background,
//             AppColors.background.withValues(alpha:0.8),
//           ],
//         ),
//       ),
//     );
//   }
// }
