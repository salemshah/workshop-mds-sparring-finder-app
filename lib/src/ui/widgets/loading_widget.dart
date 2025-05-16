import 'package:flutter/material.dart';

/// A reusable widget that displays a centered [CircularProgressIndicator].
///
/// This widget is designed to be used in place of hardcoded loading spinners
/// in your app, ensuring a consistent loading UI across your application.
class LoadingWidget extends StatelessWidget {
  /// The width and height of the loading indicator.
  final double size;

  /// The color of the loading indicator. If not provided, the theme's primary color is used.
  final Color? color;

  /// Creates a [LoadingWidget].
  ///
  /// The [size] defaults to 50.0 if not specified.
  const LoadingWidget({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          // If a color is provided, use it. Otherwise, use the current theme's primary color.
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
