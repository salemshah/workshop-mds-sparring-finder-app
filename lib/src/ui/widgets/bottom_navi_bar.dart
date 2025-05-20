// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';
//
// class BottomNavBar extends StatelessWidget {
//   const BottomNavBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: AppColors.inputFill,
//       selectedItemColor: AppColors.primary,
//       unselectedItemColor: Colors.white60,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Sparring'),
//         BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
//         BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
//         BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
//       ],
//     );
//
//   }
// }


import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: AppColors.background,
      color: AppColors.inputFill,
      buttonBackgroundColor: AppColors.primary,
      height: 60,
      animationDuration: AppTheme.mediumAnimation,
      index: currentIndex,
      onTap: onTap,
      items: [
        _buildNavItem(Icons.home, 0),
        _buildNavItem(Icons.flash_on, 1),
        _buildNavItem(Icons.message, 2),
        _buildNavItem(Icons.favorite, 3),
        _buildNavItem(Icons.account_circle, 4),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Icon(
      icon,
      size: 30,
      color: currentIndex == index ? Colors.white : Colors.white60,
    );
  }
}
