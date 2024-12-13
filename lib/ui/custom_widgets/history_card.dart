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
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.5),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                _formatDate(order.date),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.0),
                Text(
                  'Table ${order.tableNumber}',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
                Text(
                  'EGP ${order.totalBill} - ${order.items.length} Items',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                _buildItemImages(order.items),
              ],
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, color: AppColors.background),
            onTap: onTap,
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Icon(
              order.status == 'paid' ? Icons.check_circle : Icons.info,
              color: order.status == 'paid' ? Colors.green : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImages(List<OrderItem> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image.network(
                item.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
