import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  final String label;
  final Color badgeColor;
  final double size;
  final VoidCallback? onPressed; // Add onPressed callback

  const BadgeIcon({
    required this.label,
    this.badgeColor = Colors.blue,
    this.size = 100,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Use GestureDetector to detect taps
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: badgeColor.withOpacity(0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: Offset(-2, -2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.12,
            ),
          ),
        ),
      ),
    );
  }
}
