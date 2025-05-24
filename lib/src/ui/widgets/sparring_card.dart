import 'package:flutter/material.dart';
import 'package:sparring_finder/src/ui/widgets/text_auto_scroll.dart';

import '../theme/app_colors.dart';

class SparringCard extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String age;
  final String photoUrl;
  final String invitedFirstName;
  final String invitedLastName;
  final String invitedAge;
  final String invitedPhotoUrl;
  final String scheduledDate;
  final String location;
  final String startTime;
  final String cardStatus;

  const SparringCard(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.age,
      required this.photoUrl,
      required this.scheduledDate,
      required this.location,
      required this.startTime,
      required this.invitedFirstName,
      required this.invitedLastName,
      required this.invitedAge,
      required this.invitedPhotoUrl,
      required this.cardStatus});

  @override
  State<SparringCard> createState() => _SparringCardState();
}

class _SparringCardState extends State<SparringCard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final Color cardColor = widget.cardStatus == "PENDING"
        ? AppColors.cardPending
        : widget.cardStatus == "CONFIRMED"
        ? AppColors.primary
        : AppColors.cardCancelled;

    final Color cardTextColor = widget.cardStatus == "PENDING"
        ? AppColors.cardPendingText
        : widget.cardStatus == "CONFIRMED"
        ? AppColors.white
        : AppColors.white;

    return Container(
      width: width - 10,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cardColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Red Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.scheduledDate,
                  style: TextStyle(
                    color: cardTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.center,
                  child: TextAutoScroll(
                    text: widget.location,
                    style: TextStyle(
                      color: cardTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                Text(
                  widget.startTime,
                  style: TextStyle(
                    color: cardTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Body with Fighter Info and VS line
          Container(
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: FighterInfo(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      age: widget.age,
                      photoUrl: widget.photoUrl,
                    )),
                    SizedBox(width: 50),
                    Expanded(
                        child: FighterInfo(
                      firstName: widget.invitedFirstName,
                      lastName: widget.invitedLastName,
                      age: widget.invitedAge,
                      photoUrl: widget.invitedPhotoUrl,
                    )),
                  ],
                ),
                CustomPaint(
                  size: const Size(300, 260),
                  painter: VsLinePainter(color: cardColor),
                ),
                Positioned(
                  child: Text(
                    "V S",
                    style: TextStyle(
                        fontSize: 32,
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FighterInfo extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String age;
  final String photoUrl;

  const FighterInfo({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.text, width: 2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.inputFill,
            backgroundImage: NetworkImage(photoUrl),
          ),
        ),
        const SizedBox(height: 8),
        TextAutoScroll(
          text: firstName,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),

        TextAutoScroll(
          text: lastName,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Age: $age Years",
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 12,
            // fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class VsLinePainter extends CustomPainter {
  final Color color;

  VsLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width * 0.60, (size.height * 0.0) - 5),
      Offset(size.width * 0.40, size.height * 1.0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
