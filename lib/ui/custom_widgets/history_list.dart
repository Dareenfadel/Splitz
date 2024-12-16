import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/custom_widgets/history_card.dart';
import 'package:splitz/ui/screens/shared_screens/order_details_screen.dart';

class HistoryList extends StatelessWidget {
  final String restaurantId;
  final OrderService _orderService = OrderService();

  HistoryList({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    return FutureBuilder<List<Order>>(
      future: user?.userType == 'manager'
          ? _orderService.fetchOrdersByRestaurant(restaurantId)
          : _orderService.fetchOrdersByClient(user!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No orders found'));
        } else {
          final orders = snapshot.data!;

          final filteredOrders =
              orders.where((order) => order.status != 'ordering').toList();

          // Sort orders by date
          filteredOrders.sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
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
