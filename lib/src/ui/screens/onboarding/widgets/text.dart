import 'package:flutter/material.dart';

class FadeInText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;
  final Duration duration;

  const FadeInText(
      this.text, {
        super.key,
        required this.style,
        this.maxLines = 1,
        this.overflow = TextOverflow.visible,
        this.duration = const Duration(milliseconds: 800),
      });

  @override
  State<FadeInText> createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: TextAlign.center,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}
