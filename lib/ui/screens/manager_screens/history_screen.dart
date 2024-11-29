import 'package:flutter/material.dart';
import 'package:splitz/ui/custom_widgets/history_list.dart';
import '../../../constants/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  final String restaurantId;
  HistoryScreen({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders History'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.textColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Center(
        child: HistoryList(restaurantId: restaurantId),
      ),
    );
  }
}
