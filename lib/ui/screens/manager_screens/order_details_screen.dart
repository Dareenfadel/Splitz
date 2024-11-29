import 'package:flutter/material.dart';
import 'package:splitz/data/models/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  OrderDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.orderId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Customer Name: not yet', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Total Amount: \$${order.totalBill}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Order Date: ${order.date}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            // Text('Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // ...order.items.map((item) => Text('${item.name} - \$${item.price}')),
          ],
        ),
      ),
    );
  }
}
