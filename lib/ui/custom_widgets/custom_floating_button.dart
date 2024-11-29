import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double size;
  final String label;

  // Constructor to accept customizations
  CustomFloatingButton({
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.textColor,
    this.size = 60.0,
    this.label = '+', // Default label is "+"
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
                size / 2), // This makes it a perfect circle
            boxShadow: [
              BoxShadow(
                color: AppColors.background,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: size / 2,
                fontWeight: FontWeight.w300,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
