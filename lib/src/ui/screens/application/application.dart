import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_navi_bar.dart';
import '../home/home_screen.dart';
import '../profile/profile.dart';
import '../../common/placeholder_screen.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  ApplicationScreenState createState() => ApplicationScreenState();
}

class ApplicationScreenState extends State<ApplicationScreen> {
  int _currentIndex = 0;
  
  // List of screens to be displayed based on the selected tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const PlaceholderScreen(title: "Sparring", icon: Icons.flash_on),
    const PlaceholderScreen(title: "Messages", icon: Icons.message),
    const PlaceholderScreen(title: "Favorites", icon: Icons.favorite),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true, // Important for curved navigation bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
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
          ),
          
          // Main content with animated transition
          AnimatedSwitcher(
            duration: AppTheme.mediumAnimation,
            transitionBuilder: (Widget child, Animation<double> animation) {
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
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_currentIndex),
              child: _screens[_currentIndex],
            ),
          ),
        ],
      ),
    );
  }
}
