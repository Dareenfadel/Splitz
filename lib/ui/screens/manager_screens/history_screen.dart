import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/ui/custom_widgets/history_list.dart';
import '../../../constants/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  final String restaurantId;
  HistoryScreen({required this.restaurantId});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<void> _refreshHistory() async {
    // Add your refresh logic here
    await Future.delayed(Duration(seconds: 2)); // Simulate network request
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

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
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        child: Center(
          child: HistoryList(restaurantId: widget.restaurantId),
        ),
      ),
    );
  }
}
