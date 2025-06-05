import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/global.dart';
import 'package:sparring_finder/src/blocs/profile/profile_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_event.dart';
import 'package:sparring_finder/src/blocs/profile/profile_state.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/constants/app_contants.dart';
import 'package:sparring_finder/src/ui/skeletons/profile_screen_skeleton.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import 'package:sparring_finder/src/ui/widgets/profile_avatar.dart';
import 'package:sparring_finder/src/ui/widgets/text_auto_scroll.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';

import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';

class SettingItem {
  final String title;
  final IconData icon;
  final Function() onTap;
  final bool isDestructive;

  SettingItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingScreen());
  }

  @override
  State<SettingScreen> createState() => _SettingPage();
}

class _SettingPage extends State<SettingScreen> {
  bool _isDeleting = false;

  void _rateApp() async {
    const appId = 'fr.sparring-finder'; // Replace with your actual app ID
    try {
      // For Android
      final androidUrl = Uri.parse(
        'market://details?id=$appId',
      );
      // For iOS
      final iosUrl = Uri.parse(
        'https://apps.apple.com/app/id$appId',
      );

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await canLaunchUrl(iosUrl)) {
          await launchUrl(iosUrl);
        }
      } else {
        if (await canLaunchUrl(androidUrl)) {
          await launchUrl(androidUrl);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d\'ouvrir la page de notation'),
        ),
      );
    }
  }

  void _shareApp() {
    const String message =
        "Découvrez Sparring Finder, l'application qui vous aide à trouver des partenaires de sparring près de chez vous ! 🥊\n\n"
        'Téléchargez-la maintenant sur : https://testflight.apple.com/join/Ec5zapXB';
    Share.share(message);
  }

  void _showDeleteAccountDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Supprimer le compte",
            style: TextStyle(
              color: kRed,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Cette action est irréversible. Toutes vos données seront supprimées définitivement.",
            style: TextStyle(
              fontSize: 12,
              color: primaryColor,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Annuler",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                "Supprimer",
                style: TextStyle(
                  color: kRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () async {
                try {
                  setState(() => _isDeleting = true);
                  Navigator.of(context).pop(); // Close dialog

                  // Show loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Row(
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(width: 20),
                            const Text("Suppression du compte..."),
                          ],
                        ),
                      );
                    },
                  );

                  Global.storageService.resetStorage();

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.loginScreen,
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  Navigator.of(context).pop(); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Erreur lors de la suppression: ${e.toString()}'),
                      backgroundColor: kRed,
                    ),
                  );
                } finally {
                  setState(() => _isDeleting = false);
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryBackground,
              primaryBackground.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header with user info
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              // Settings sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              // Account Section
              SliverToBoxAdapter(
                child: _buildSection(
                  title: "Account",
                  icon: Icons.account_circle,
                  iconColor: kRed,
                  items: [
                    SettingItem(
                      title: "Update Account",
                      icon: Icons.edit_outlined,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.updateProfileScreen);
                      },
                    ),
                    SettingItem(
                      title: "Change Password",
                      icon: Icons.lock_outline,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.forgotPasswordScreen);
                      },
                    ),
                  ],
                ),
              ),

              // About Section
              SliverToBoxAdapter(
                child: _buildSection(
                  title: "About",
                  icon: Icons.info_outline,
                  iconColor: Colors.blue,
                  items: [
                    SettingItem(
                      title: "Privacy Policy",
                      icon: Icons.privacy_tip_outlined,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.privacyPolicyScreen);
                      },
                    ),
                    SettingItem(
                      title: "Terms of Service",
                      icon: Icons.article_outlined,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.termsOfServiceScreen);
                      },
                    ),
                    SettingItem(
                      title: "Contact Us",
                      icon: Icons.mail_outline,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.contactUsScreen);
                      },
                    ),
                  ],
                ),
              ),

              // Rate Section
              SliverToBoxAdapter(
                child: _buildSection(
                  title: "Rate & Share",
                  icon: Icons.star_outline,
                  iconColor: Colors.amber,
                  items: [
                    SettingItem(
                      title: "Rate the App",
                      icon: Icons.star_rate_outlined,
                      onTap: _rateApp,
                    ),
                    SettingItem(
                      title: "Share the App",
                      icon: Icons.share_outlined,
                      onTap: _shareApp,
                    ),
                  ],
                ),
              ),

              // Danger Zone
              SliverToBoxAdapter(
                child: _buildSection(
                  title: "Danger Zone",
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.red,
                  items: [
                    SettingItem(
                      title: "Delete Account",
                      icon: Icons.delete_forever,
                      isDestructive: true,
                      onTap: _showDeleteAccountDialog,
                    ),
                  ],
                ),
              ),

              // Logout Button
              SliverToBoxAdapter(
                child: _buildLogoutButton(),
              ),

              // Version info
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 40),
                  child: Center(
                    child: Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<MyProfileBloc, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoadInProgress) {
          return const ProfileSkeleton();
        } else if (state is MyProfileFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load profile',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                SizedBox(height: 16.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onPressed: () =>
                      context.read<MyProfileBloc>().add(MyProfileRequested()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is MyProfileLoadSuccess) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.text, width: 2),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: ProfileAvatar(
                    radius: 30.r,
                    photoUrl: state.profile.photoUrl,
                  ),
                ),
                SizedBox(height: 15.h),
                TextAutoScroll(
                  text: "${state.profile.firstName} ${state.profile.lastName}".capitalizeEachWord(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                ],
            ),
          );
        }
        return const ProfileSkeleton();
      },
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<SettingItem> items,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 12,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Divider
              Divider(
                color: Colors.white.withValues(alpha: 0.1),
                height: 1,
              ),

              // Items
              ...items.map((item) => _buildListItem(item)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(SettingItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.isDestructive
                    ? Colors.red.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                color: item.isDestructive ? Colors.red : Colors.white,
                size: 12,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: item.isDestructive ? Colors.red : AppColors.text,
                    fontSize: 12),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: item.isDestructive
                  ? Colors.red.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                title: Text(
                  "Confirm Logout",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                      fontSize: 12),
                ),
                content: Text(
                  "Are you sure you want to log out? You will need to log in again to access your account.",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                      fontSize: 12),
                ),
                actions: [
                  TextButton(
                    child: Text("Cancel",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                            fontSize: 12)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                            fontSize: 12)),
                    onPressed: () {
                      context.read<UserBloc>().add(const UserLogoutRequested());
                    },
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kRed,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: primaryBackground,
      elevation: 0,
      leading: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        onTap: () => Navigator.of(context).pop(),
      ),
      title: Text(
        "Settings",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }
}
