import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;

  const BadgeWidget({
    Key? key,
    required this.label,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Solid outer circle
          CustomPaint(
            size: const Size(100, 100),
            painter: SolidCirclePainter(
              color: Colors.black,
              strokeWidth: 3,
            ),
          ),
          // Solid circle for background
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
          ),
          // Dashed inner circle
          CustomPaint(
            size: const Size(100, 100),
            painter: DashedCirclePainter(
              color: Colors.black,
              strokeWidth: 2,
              dashLength: 5,
              radiusFactor: 0.85, // Adjust radius of dashed circle
            ),
          ),
          // Label text with ChickenWonder font
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'ChickenWonder', // Specify the ChickenWonder font
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SolidCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  SolidCirclePainter({
    required this.color,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2 - strokeWidth / 2;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double radiusFactor;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 5.0,
    this.radiusFactor = 0.85, // Reduced to make the dashed line smaller
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = (size.width / 2) * radiusFactor - strokeWidth;
    const double gapSize = 5.0;

    double totalCircumference = 2 * 3.141592653589793 * radius;
    double dashCount =
        (totalCircumference / (dashLength + gapSize)).floorToDouble();

    double dashSpacingAngle = (2 * 3.141592653589793) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      double startAngle = i * dashSpacingAngle;
      double endAngle = startAngle +
          (dashSpacingAngle * (dashLength / (dashLength + gapSize)));

      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
