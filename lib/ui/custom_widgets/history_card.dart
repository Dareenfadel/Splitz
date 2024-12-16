import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import '../../constants/app_colors.dart';

class HistoryCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  HistoryCard({required this.order, required this.onTap});

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('EEEE, d MMMM');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.5),
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                _formatDate(order.date),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 1.0),
                Text(
                  'Table ${order.tableNumber}',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'EGP ${order.totalBill} - ${order.items.length} Items',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: AppColors.background),
            onTap: onTap,
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Icon(
              order.status == 'paid'
                  ? Icons.check_circle
                  : Icons.hourglass_top_rounded,
              color: order.status == 'paid' ? Colors.green : AppColors.primary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
