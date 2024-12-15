import 'package:flutter/material.dart';
import '../../data/models/order.dart';
import '../../data/services/order_service.dart';
import 'order_card.dart';

class OrdersList extends StatefulWidget {
  final String restaurantId;
  final String orderStatus;

  OrdersList({required this.restaurantId, required this.orderStatus});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final OrderService _orderService = OrderService();
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
  }

  void updateOrderList(Order updatedOrder) {
    setState(() {
      // Find the index of the order and update it
      int index =
          orders.indexWhere((order) => order.orderId == updatedOrder.orderId);
      if (index != -1) {
        // Update the order at the found index
        orders[index] = updatedOrder;

        // Move the updated order to the top of the list
        orders.insert(0, orders.removeAt(index));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream:
          _orderService.fetchOrders(widget.restaurantId, widget.orderStatus),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No orders ${widget.orderStatus.toLowerCase()}',
                style: const TextStyle(fontSize: 18)),
          );
        }

        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
                order: order,
                orderId: order.orderId,
                updateStatus: (newStatus) =>
                    _orderService.updateOrderStatus(order.orderId, newStatus),
                onFlagChanged: updateOrderList);
          },
        );
      },
    );
  }
}
