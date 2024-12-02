import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class MenuScreen extends StatelessWidget {
  String restaurantId;
  MenuScreen({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: const Center(
        child: Text(
          'Menu',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
