import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: const Center(
        child: Text(
          'Orders',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
