import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring_finder/src/constants/app_contants.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
      backgroundColor: primaryBackground,
      appBar: AppBar(
        backgroundColor: primaryBackground,
        title: Text(
          'Terms of Service',
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
                  "By using our sparring finder app, you agree to the following terms and conditions. Please read them carefully."),
              buildSectionTitle("1. Use of Service"),
              buildParagraph("- You must be at least 16 years old.\n"
                  "- Use the app for training and sparring purposes only.\n"
                  "- Do not engage in offensive, illegal, or dangerous behavior."),
              buildSectionTitle("2. Account Responsibilities"),
              buildParagraph("- Keep your profile accurate and up-to-date.\n"
                  "- You are responsible for all activities under your account.\n"
                  "- Report any unauthorized use immediately."),
              buildSectionTitle("3. Matchmaking Rules"),
              buildParagraph(
                  "- Respect other users' preferences and availability.\n"
                  "- You may cancel or reschedule with proper notice.\n"
                  "- Repeated no-shows may result in account restrictions."),
              buildSectionTitle("4. Limitation of Liability"),
              buildParagraph(
                  "- We do not assume responsibility for physical injuries.\n"
                  "- Use the app at your own risk.\n"
                  "- We are not liable for user-generated content."),
              buildSectionTitle("5. Account Suspension"),
              buildParagraph(
                  "- We may suspend or terminate your account if terms are violated.\n"
                  "- We reserve the right to refuse service at our discretion."),
              buildSectionTitle("6. Changes to Terms"),
              buildParagraph("- Terms may be updated from time to time.\n"
                  "- We will notify users via the app or email."),
              buildSectionTitle("7. Contact"),
              buildParagraph(
                  "If you have any questions about these Terms, contact us at:\n\n"
                  "📧 legal@sparring-finder.com\n"
                  "Subject: Terms of Service"),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "Train smart. Stay safe.",
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
