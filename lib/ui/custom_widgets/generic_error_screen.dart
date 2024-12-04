import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:splitz/constants/app_colors.dart';

class GenericErrorScreen extends StatelessWidget {
  final String message;
  final IconData icon;
  String? details;

  GenericErrorScreen({
    super.key,
    this.message = 'Something went wrong',
    this.icon = Icons.error_outline,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              if (details != null) ...[
                const SizedBox(height: 16),
                Text(
                  details!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ));
  }
}
