import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';

// Custom Elevated Button Widget
class CustomElevatedButton extends StatelessWidget {
  final String text; // Text to display on the button
  final Color backgroundColor; // Background color of the button
  final Color textColor; // Color of the text
  final VoidCallback onPressed; // Callback for button press
  final double width; // Width of the button (optional, default is full width)
  final double height; // Height of the button (optional, default is 50)
  final BorderRadiusGeometry borderRadius; // Border radius (optional)

  CustomElevatedButton({
    required this.text,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.textColor,
    required this.onPressed,
    this.width = double.infinity, // Default width to full width
    this.height = 55.0, // Default height
    this.borderRadius =
        const BorderRadius.all(Radius.circular(30.0)), // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text, // Display the text
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
