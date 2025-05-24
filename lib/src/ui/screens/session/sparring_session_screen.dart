import 'package:flutter/material.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';
import 'package:sparring_finder/src/ui/widgets/sparring_card.dart';

class MatchCardScreen extends StatelessWidget {
  const MatchCardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SparringCard(
          firstName: "John",
          lastName: "Doe",
          age: "29",
          photoUrl: "https://cdn-icons-png.flaticon.com/512/147/147144.png",

          invitedFirstName: "Ali",
          invitedLastName: "Rezaei",
          invitedAge: "30",
          invitedPhotoUrl: "https://cdn-icons-png.flaticon.com/512/147/147142.png",

          scheduledDate: "2025-06-05",
          location: "Paris",
          startTime: "15:00",
        )
      ),
    );
  }
}
