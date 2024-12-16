import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';

class MenuCatrgoeyItem extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onPressed;
  final IconData? icon = Icons.arrow_forward;
  final String defaultImageUrl =
      'https://t3.ftcdn.net/jpg/04/60/01/36/360_F_460013622_6xF8uN6ubMvLx0tAJECBHfKPoNOR5cRa.jpg';

  MenuCatrgoeyItem({
    required this.imageUrl,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.textColor,
          borderRadius: BorderRadius.circular(70),
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(children: [
                SizedBox(height: 25),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: imageUrl != ''
                      ? Image.network(
                          imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network(
                            defaultImageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        )
                      : SizedBox(width: 50, height: 50, child: Icon(icon)),
                ),
                SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
