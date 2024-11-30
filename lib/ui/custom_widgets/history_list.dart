import 'package:flutter/material.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/custom_widgets/history_card.dart';
import 'package:splitz/ui/screens/manager_screens/order_details_screen.dart';

class HistoryList extends StatelessWidget {
  final String restaurantId;
  final OrderService _orderService = OrderService();

  HistoryList({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _orderService.fetchOrdersByRestaurant(restaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No orders found'));
        } else {
          final orders = snapshot.data!;
          orders
              .sort((a, b) => b.date.compareTo(a.date)); // Sort orders by date
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return HistoryCard(
                order: order,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsScreen(order: order),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
