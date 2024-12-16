import 'dart:async';
import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/custom_widgets/item_preview.dart';
import '../../data/models/order.dart';
import 'order_details.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final String orderId;
  final Function(String) updateStatus;
  bool hasNewItems;

  OrderCard({
    required this.order,
    required this.orderId,
    required this.updateStatus,
    required this.hasNewItems,
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late List<OrderItem> items;
  final OrderService _orderService = OrderService();
  late StreamSubscription<List<Order>> _orderSubscription;

  @override
  void initState() {
    super.initState();
    items = widget.order.items;

    void updateItems(List<OrderItem> updatedItems) {
      setState(() {
        for (var updatedItem in updatedItems) {
          final updatedItemIndex = updatedItems.indexOf(updatedItem);

          if (items.elementAtOrNull(updatedItemIndex) != null) {
            if (items[updatedItemIndex].status == "ordering" &&
                updatedItem.status == "pending") {
              widget.updateStatus("pending");
            }
          } else {
            items.add(updatedItem);
          }
        }
      });
    }

    _orderSubscription = _orderService
        .listenToOrdersByRestaurant(widget.order.restaurantId)
        .listen((orders) {
      final updatedOrder = orders.firstWhere(
          (order) => order.orderId == widget.orderId,
          orElse: () => widget.order);

      updateItems(updatedOrder.items);
    });
  }

  void updateFlag(bool newValue) {
    setState(() {
      widget.hasNewItems = newValue;
    });
  }

  @override
  void dispose() {
    _orderSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tableNumber = widget.order.tableNumber;
    final orderStatus = widget.order.status;
    final firstTwoItems = widget.order.items.take(2).toList();

    String getOrderStatusText(String status) {
      switch (status) {
        case "pending":
          return "Start order";
        case "in progress":
          return "Mark as served";
        case "served":
          return "Mark as paid";
        default:
          return "Unknown status";
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: const EdgeInsets.only(top: 50, left: 26, right: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
                color: AppColors.secondary,
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.hasNewItems)
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.new_releases,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                ...firstTwoItems.map((item) => ItemPreview(item: item)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    FadeTransition(
                              opacity: animation,
                              child: OrderDetailsPage(
                                  order: widget.order,
                                  orderId: widget.orderId,
                                  updateStatus: (newStatus) =>
                                      widget.updateStatus(newStatus),
                                  hasNewItems: widget.hasNewItems,
                                  updateFlag: updateFlag),
                            ),
                          ));
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                          size: 20,
                        ),
                        label: const Text(
                          "View all",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.updateStatus(orderStatus == "pending"
                              ? "in progress"
                              : orderStatus == "in progress"
                                  ? "served"
                                  : "paid");
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(getOrderStatusText(orderStatus),
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 16,
          right: 16,
          child: Center(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: AppColors.secondary,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 12.0),
                  child: Column(
                    children: [
                      const Text(
                        "TABLE",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        tableNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
