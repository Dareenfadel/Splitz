import 'package:flutter/material.dart';
import 'package:splitz/data/models/order.dart';
import '../../constants/app_colors.dart';

class HistoryCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  HistoryCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondary,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          'Order #${order.orderId}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text('Date: ${order.date}',
                style: TextStyle(color: AppColors.textColor)),
            SizedBox(height: 4.0),
            Text('Total: \$${order.totalBill}',
                style: TextStyle(color: AppColors.textColor)),
            SizedBox(height: 4.0),
            Text('Status: ${order.status}',
                style: TextStyle(color: AppColors.textColor)),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: AppColors.background),
        onTap: onTap,
      ),
    );
  }
}
