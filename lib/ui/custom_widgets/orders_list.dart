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

  bool checkNewItems(Order order) {
    bool hasPendingItem = false;
    bool hasOtherItem = false;

    for (var item in order.items) {
      if (item.status == "pending") {
        hasPendingItem = true;
      } else if (item.status != "ordering") {
        hasOtherItem = true;
      }

      if (hasPendingItem && hasOtherItem) {
        break;
      }
    }
    return hasPendingItem && hasOtherItem;
  }

  void sortOrders() {
    orders.sort((a, b) {
      bool aHasNewItems = checkNewItems(a);
      bool bHasNewItems = checkNewItems(b);

      if (aHasNewItems && !bHasNewItems) {
        return -1;
      } else if (!aHasNewItems && bHasNewItems) {
        return 1;
      }
      return 0;
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

        orders = snapshot.data!;
        sortOrders();

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            bool hasNewItems = checkNewItems(order);
            return OrderCard(
              order: order,
              orderId: order.orderId,
              updateStatus: (newStatus) =>
                  _orderService.updateOrderStatus(order.orderId, newStatus),
              hasNewItems: hasNewItems,
            );
          },
        );
      },
    );
  }
}
