import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_bloc.dart';
import 'package:sparring_finder/src/blocs/user/user_state.dart';
import 'package:sparring_finder/src/ui/screens/availability/availability_calender_screen.dart';
import 'package:sparring_finder/src/ui/screens/session/sparring_session_screen.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_state.dart';
import '../../../config/app_routes.dart';
import '../../common/placeholder_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_navi_bar.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

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
    PlaceholderScreen(title: "Messages", icon: Icons.message),
    AvailabilityCalendarScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserUnauthenticated) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.loginScreen,
                (route) => false,
              );
            }
          },
        ),
        BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationNavigate) {
              Navigator.pushNamed(
                context,
                state.routeName,
                arguments: state.arguments,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
// import '../profile/profile_screen.dart';
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
