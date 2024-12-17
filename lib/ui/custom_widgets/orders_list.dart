import 'package:flutter/material.dart';
import 'package:splitz/ui/custom_widgets/message_container.dart';
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
          return const Center(
              child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          var status = widget.orderStatus.toLowerCase();
          return MessageContainer(
              icon: status == "pending"
                  ? Icons.hourglass_empty_rounded
                  : status == "in progress"
                      ? Icons.hourglass_bottom_rounded
                      : Icons.hourglass_full_rounded,
              message: 'No orders ${widget.orderStatus.toLowerCase()}',
              subMessage: "");
        }

        orders = snapshot.data!;
        sortOrders();

        bool hasDisplayedOrders = orders.any(
            (order) => order.items.any((item) => item.status != 'ordering'));

        final ordersList = ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            bool hasNewItems = checkNewItems(order);
            bool allItemsOrdering =
                order.items.every((item) => item.status == 'ordering');

            print('$allItemsOrdering ');
            if (!allItemsOrdering) {
              hasDisplayedOrders = true;
              print('$hasDisplayedOrders shje');
              return OrderCard(
                order: order,
                orderId: order.orderId,
                updateStatus: (newStatus) =>
                    _orderService.updateOrderStatus(order.orderId, newStatus),
                hasNewItems: hasNewItems,
              );
            }
            print(hasDisplayedOrders);
            return const SizedBox.shrink();
          },
        );

        if (!hasDisplayedOrders) {
          return MessageContainer(
              icon: Icons.hourglass_empty_rounded,
              message: 'No orders ${widget.orderStatus.toLowerCase()}',
              subMessage: "");
        } else {
          return ordersList;
        }
      },
    );
  }
}
