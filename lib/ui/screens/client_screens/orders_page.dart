//create a simple screen to navigate to
import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
//empty screen
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Orders Page'),
      ),
    );
  }
}