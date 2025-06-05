import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 15,
          height: 1.7,
          color: AppColors.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        foregroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Effective Date: June 4, 2025",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              buildParagraph(
                  "Welcome to our sparring finder app. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information."),
              buildSectionTitle("1. Information We Collect"),
              buildParagraph(
                  "- Profile Information: name, picture, level, weight class, training style, and bio.\n"
                  "- Location Data: for local partner suggestions.\n"
                  "- Availability: preferred training times.\n"
                  "- Match History: records of sessions.\n"
                  "- Device Info: version, device type, error logs."),
              buildSectionTitle("2. How We Use Your Information"),
              buildParagraph("- Match users based on skill and availability.\n"
                  "- Display your availability to others.\n"
                  "- Enable scheduling and reminders.\n"
                  "- Improve platform performance."),
              buildSectionTitle("3. Data Security"),
              buildParagraph("- Data stored on encrypted servers.\n"
                  "- No sharing with third-party advertisers.\n"
                  "- Limited access to admin team only."),
              buildSectionTitle("4. Your Rights"),
              buildParagraph("- Edit or delete your profile any time.\n"
                  "- Request data deletion.\n"
                  "- Request access to stored info."),
              buildSectionTitle("5. Data Sharing"),
              buildParagraph("- With consent, for sparring matches.\n"
                  "- With authorities if legally required.\n"
                  "- During company merger (with notice)."),
              buildSectionTitle("6. Contact Us"),
              buildParagraph(
                  "For any questions or requests about your data, please contact us at:\n\n"
                  "📧 support@sparing-finder.com\n"
                  "Subject: Privacy & Data Rights"),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "Thank you for trusting us.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
