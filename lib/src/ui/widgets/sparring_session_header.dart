import 'package:flutter/material.dart';
import 'package:sparring_finder/src/ui/theme/app_colors.dart';

class SparringSessionHeader extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double bannerHeight = size.height;
    final double bannerWidth = size.width;
    final double radius = 8;

    final Paint borderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint fillPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;

    final Paint bluePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Rounded Left Banner
    final leftPoints = [
      Offset(0, bannerHeight / 4),
      Offset(bannerWidth * 0.50, 0),
      Offset(bannerWidth * 0.35, bannerHeight),
      Offset(0, bannerHeight * 3 / 4),
      Offset(0, bannerHeight / 4),
    ];
    final leftPath = createRoundedPath(leftPoints, radius);

    // Rounded Right Banner
    final rightPoints = [
      Offset(bannerWidth, bannerHeight / 4),
      Offset(bannerWidth * 0.50, 0),
      Offset(bannerWidth * 0.65, bannerHeight),
      Offset(bannerWidth, bannerHeight * 3 / 4),
      Offset(bannerWidth, bannerHeight / 4),
    ];
    final rightPath = createRoundedPath(rightPoints, radius);

    canvas.drawPath(leftPath, fillPaint);
    canvas.drawPath(leftPath, borderPaint);
    canvas.drawPath(rightPath, fillPaint);
    canvas.drawPath(rightPath, borderPaint);

    // Blue circles and rectangles
    canvas.drawCircle(
        Offset(bannerWidth * 0.07, bannerHeight / 2), 12, bluePaint);
    canvas.drawCircle(
        Offset(bannerWidth * 0.93, bannerHeight / 2), 12, bluePaint);
    canvas.drawRect(
        Rect.fromLTWH(bannerWidth * 0.12, bannerHeight * 0.3, bannerWidth * 0.2,
            bannerHeight * 0.4),
        bluePaint);
    canvas.drawRect(
        Rect.fromLTWH(bannerWidth * 0.68, bannerHeight * 0.3, bannerWidth * 0.2,
            bannerHeight * 0.4),
        bluePaint);

    // VS circle and text
    final double vsRadius = bannerHeight * 0.5;
    final Offset vsCenter = Offset(bannerWidth / 2, bannerHeight / 2);
    canvas.drawCircle(vsCenter, vsRadius, fillPaint);
    canvas.drawCircle(vsCenter, vsRadius, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'VS',
        style: TextStyle(
            color: AppColors.primary,
            fontSize: bannerHeight * 0.4,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(vsCenter.dx - textPainter.width / 2,
            vsCenter.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Path createRoundedPath(List<Offset> points, double radius) {
  final path = Path();
  if (points.length < 3) return path;

  path.moveTo(points[0].dx, points[0].dy);

  for (int i = 1; i < points.length - 1; i++) {
    final prev = points[i - 1];
    final curr = points[i];
    final next = points[i + 1];

    final start = Offset.lerp(curr, prev, radius / (curr - prev).distance)!;
    final end = Offset.lerp(curr, next, radius / (curr - next).distance)!;

    path.lineTo(start.dx, start.dy);
    path.quadraticBezierTo(curr.dx, curr.dy, end.dx, end.dy);
  }

  path.lineTo(points.last.dx, points.last.dy);
  path.close();

  return path;
}
