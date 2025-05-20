import 'package:flutter/material.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';

class MatchCardScreen extends StatelessWidget {
  const MatchCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1E21),
      body: Center(
        child: Container(
          width: width - 10,
          // margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Red Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  // color: Color(0xFFD13D2F),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "April 27 2025",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "15:00",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Body with Fighter Info and VS line
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2E33),
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: Colors.red, width: 1),
                ),
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        FighterInfo(
                          name: "Salem",
                          surname: "SHAH",
                          age: 27,
                          imageUrl: 'https://cdn-icons-png.flaticon.com/512/147/147144.png', // Replace with real image
                        ),
                        FighterInfo(
                          name: "Karim",
                          surname: "AHMADI",
                          age: 28,
                          imageUrl: 'https://cdn-icons-png.flaticon.com/512/147/147142.png', // Replace with real image
                        ),
                      ],
                    ),
                    CustomPaint(
                      size: const Size(300, 260),
                      painter: VsLinePainter(),
                    ),
                    const Positioned(
                      child: Text(
                        "VS",
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFFD13D2F),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FighterInfo extends StatelessWidget {
  final String name;
  final String surname;
  final int age;
  final String imageUrl;

  const FighterInfo({
    super.key,
    required this.name,
    required this.surname,
    required this.age,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(height: 15),
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          surname,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Age: $age Years",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            // fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class VsLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD13D2F)
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
