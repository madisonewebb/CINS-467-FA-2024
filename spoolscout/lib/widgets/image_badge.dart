import 'package:flutter/material.dart';

class ImageBadgeWidget extends StatelessWidget {
  final String imageUrl;
  final Color backgroundColor;

  const ImageBadgeWidget({
    Key? key,
    required this.imageUrl,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Increased size
      height: 180, // Increased size
      margin: const EdgeInsets.symmetric(horizontal: 16), // Adjusted spacing
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Solid outer circle
          CustomPaint(
            size: const Size(180, 180), // Adjust size
            painter: SolidCirclePainter(
              color: Colors.black,
              strokeWidth: 6, // Increased stroke width
            ),
          ),
          // Solid circle for background
          Container(
            width: 160, // Increased size
            height: 160, // Increased size
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
          ),
          // Dashed inner circle
          CustomPaint(
            size: const Size(180, 180), // Adjust size
            painter: DashedCirclePainter(
              color: Colors.black,
              strokeWidth: 4, // Increased stroke width
              dashLength: 10, // Increased dash length
              radiusFactor: 0.85, // Keep the same radius factor
            ),
          ),
          // Image instead of text
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 140, // Adjusted size to fit the larger badge
              height: 140, // Adjusted size
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported,
                size: 60, // Larger placeholder icon
                color: Colors.grey,
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
    this.strokeWidth = 6.0, // Updated default
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
    this.strokeWidth = 4.0, // Updated default
    this.dashLength = 10.0, // Updated default
    this.radiusFactor = 0.85, // Keep the same
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = (size.width / 2) * radiusFactor - strokeWidth;
    const double gapSize = 10.0; // Adjusted to match new dashLength

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
