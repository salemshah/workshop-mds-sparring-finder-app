import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class TextAutoScroll extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double height;
  final double velocity;

  const TextAutoScroll({
    super.key,
    required this.text,
    this.style,
    this.height = 20,
    this.velocity = 30,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: double.infinity);

        final textWidth = textPainter.size.width;
        final availableWidth = constraints.maxWidth;

        final shouldScroll = textWidth > availableWidth;

        return SizedBox(
          height: height,
          child: shouldScroll
              ? Marquee(
            text: text,
            style: style,
            velocity: velocity,
            blankSpace: 50,
            pauseAfterRound: const Duration(seconds: 1),
            startPadding: 10,
            fadingEdgeStartFraction: 0.1,
            fadingEdgeEndFraction: 0.1,
          )
              : Text(
            text,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
