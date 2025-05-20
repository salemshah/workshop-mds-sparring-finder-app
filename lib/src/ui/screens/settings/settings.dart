import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/Global.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/constants/app_contants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';

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
    const appId = 'fr.sparring-finder.beehive'; // Replace with your actual app ID
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
    const String message = 'Découvrez Sparring Finder, l\'application qui vous permet de trouver ! '
        'Téléchargez-la maintenant sur : https://sparring-finder.fr';
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
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            "Cette action est irréversible. Toutes vos données seront supprimées définitivement.",
            style: TextStyle(
              fontSize: 14.sp,
              color: primaryColor,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Annuler",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14.sp,
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
                  fontSize: 14.sp,
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
                            SizedBox(width: 20.w),
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
                      content: Text('Erreur lors de la suppression: ${e.toString()}'),
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
            borderRadius: BorderRadius.circular(15.w),
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
              Colors.black,
              Color(0xFF121212),
              Color(0xFF1E1E1E),
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Text(
                    "Paramètres",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              
              // Account Section
              SliverToBoxAdapter(
                child: _buildSection(
                  title: "Compte",
                  icon: Icons.account_circle,
                  iconColor: kRed,
                  items: [
                    SettingItem(
                      title: "Editer mon profil",
                      icon: Icons.edit_outlined,
                      onTap: () {},
                    ),
                    SettingItem(
                      title: "Changer le mot de passe",
                      icon: Icons.lock_outline,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              
              // About Section
              SliverToBoxAdapter(
                child: _buildSection(
                  title: "À Propos",
                  icon: Icons.info_outline,
                  iconColor: Colors.blue,
                  items: [
                    SettingItem(
                      title: "Politique & Confidentialité",
                      icon: Icons.privacy_tip_outlined,
                      onTap: () {},
                    ),
                    SettingItem(
                      title: "Conditions Générales",
                      icon: Icons.description_outlined,
                      onTap: () {},
                    ),
                    SettingItem(
                      title: "Nous Contacter",
                      icon: Icons.mail_outline,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              
              // Rate Section
              SliverToBoxAdapter(
                child: _buildSection(
                  title: "Noter & Partager",
                  icon: Icons.star_outline,
                  iconColor: Colors.amber,
                  items: [
                    SettingItem(
                      title: "Noter l'application",
                      icon: Icons.star_rate_outlined,
                      onTap: _rateApp,
                    ),
                    SettingItem(
                      title: "Partager l'application",
                      icon: Icons.share_outlined,
                      onTap: _shareApp,
                    ),
                  ],
                ),
              ),
              
              // Danger Zone
              SliverToBoxAdapter(
                child: _buildSection(
                  title: "Zone de danger",
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.red,
                  items: [
                    SettingItem(
                      title: "Supprimer mon compte",
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
                  padding: EdgeInsets.only(top: 20.h, bottom: 40.h),
                  child: Center(
                    child: Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
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
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 20.h),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kRed.withOpacity(0.8), kRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kRed.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30.w,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "John Doe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "john.doe@example.com",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<SettingItem> items,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.w),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 22.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Divider
              Divider(
                color: Colors.white.withOpacity(0.1),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: item.isDestructive 
                    ? Colors.red.withOpacity(0.1) 
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Icon(
                item.icon,
                color: item.isDestructive ? Colors.red : Colors.white,
                size: 20.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  color: item.isDestructive ? Colors.red : Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: item.isDestructive 
                  ? Colors.red.withOpacity(0.7) 
                  : Colors.white.withOpacity(0.5),
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.w),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                title: Text(
                  "Confirmer la déconnexion",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                content: Text(
                  "Êtes-vous sûr de vouloir vous déconnecter ?",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14.sp,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      "Annuler",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                    ),
                    child: Text(
                      "Déconnexion",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    onPressed: () {
                      Global.storageService.resetStorage();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.loginScreen,
                        (Route<dynamic> route) => false,
                      );
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
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.w),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20.w, color: Colors.white),
            SizedBox(width: 10.w),
            Text(
              "Déconnexion",
              style: TextStyle(
                fontSize: 16.sp,
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 10.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
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
        "Réglages",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      centerTitle: true,
    );
  }
}
