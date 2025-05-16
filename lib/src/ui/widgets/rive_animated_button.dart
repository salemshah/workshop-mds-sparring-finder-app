import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveAnimatedButton extends StatelessWidget {
  final double height;
  final double width;
  final String assetPath;
  final String stateMachineName;
  final double conditionValue;
  final Alignment alignment;
  final BoxFit fit;
  final String routeName;

  const RiveAnimatedButton({
    super.key,
    required this.height,
    required this.width,
    required this.conditionValue,
    required this.routeName,
    this.assetPath = 'assets/rive_files/buttons.riv',
    this.stateMachineName = 'button_sm',
    this.alignment = Alignment.centerLeft,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTapUp: (detail) {
          Navigator.pushNamed(context, routeName);
        },
        child: RiveAnimation.asset(
          assetPath,
          stateMachines: [stateMachineName],
          alignment: alignment,
          fit: fit,
          onInit: (Artboard artboard) {
            final controller = StateMachineController.fromArtboard(
              artboard,
              stateMachineName,
            );
            if (controller == null) return;
            artboard.addController(controller);
            controller.findSMI<SMINumber>("condition")?.change(conditionValue);
          },
        ),
      ),
    );
  }
}
