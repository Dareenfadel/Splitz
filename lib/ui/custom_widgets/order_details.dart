import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/services/order_service.dart';
import 'package:splitz/ui/custom_widgets/item_details.dart';
import '../../constants/app_colors.dart';
import '../../data/models/order.dart';
import 'status_button.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  final String orderId;
  final Function(String) updateStatus;
  final bool hasNewItems;
  final Function(bool) updateFlag;

  OrderDetailsPage(
      {required this.order,
      required this.orderId,
      required this.updateStatus,
      required this.hasNewItems,
      required this.updateFlag});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late List<OrderItem> items;
  final OrderService _orderService = OrderService();
  late StreamSubscription<List<Order>> _orderSubscription;

  @override
  void initState() {
    super.initState();
    items = widget.order.items;

    if (widget.hasNewItems) {
      showToast();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.updateFlag(false);
      });
    }

    void updateItems(List<OrderItem> updatedItems) {
      setState(() {
        items = updatedItems
          ..sort((a, b) {
            const statusPriority = {
              'pending': 0,
              'in progress': 1,
              'served': 2
            };

            int statusComparison =
                statusPriority[a.status]!.compareTo(statusPriority[b.status]!);

            return statusComparison;
          });
        widget.updateStatus("pending");
      });
    }

    _orderSubscription = _orderService
        .listenToOrdersByRestaurant(widget.order.restaurantId)
        .listen((orders) {
      final updatedOrder = orders.firstWhere(
          (order) => order.orderId == widget.orderId,
          orElse: () => widget.order);

      if (updatedOrder.items.length > items.length) {
        final newItems = updatedOrder.items
            .where((newItem) => !items
                .any((existingItem) => existingItem.itemId == newItem.itemId))
            .toList();

        final validNewItems =
            newItems.where((item) => item.status != "ordering").toList();

        if (validNewItems.isNotEmpty) {
          updateItems([...items, ...validNewItems]);
        }
      }
    });
  }

  @override
  void dispose() {
    _orderSubscription.cancel();
    super.dispose();
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "New item(s) added to the order!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tableNumber = widget.order.tableNumber;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Table $tableNumber',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFFCD006A),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item.status == 'in progress' &&
                    widget.order.status == 'in progress') {
                  return Dismissible(
                    key: Key(item.itemId),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      setState(() {
                        _orderService.updateItemStatus(
                            widget.orderId, item.itemId, "served");
                        item.status = 'served';
                      });
                      return false;
                    },
                    background: Card(
                      color: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.all(20),
                        child: const Text(
                          'Served',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    child: ItemDetails(item: item),
                  );
                } else if (item.status == 'served' &&
                    widget.order.status == 'in progress') {
                  return Dismissible(
                    key: Key(item.itemId),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      setState(() {
                        _orderService.updateItemStatus(
                            widget.orderId, item.itemId, "in progress");
                        item.status = 'in progress';
                      });
                      return false;
                    },
                    background: Card(
                      color: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.all(20),
                        child: const Text(
                          'Undo',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    child: ItemDetails(item: item),
                  );
                } else {
                  return ItemDetails(item: item);
                }
              },
            ),
          ),
          if (widget.order.status == "served")
            Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total: ${widget.order.totalBill} EGP',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Paid: ${widget.order.paidSoFar} EGP',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ])),
          StatusButton(
            orderStatus: widget.order.status,
            updateStatus: widget.updateStatus,
          ),
        ],
      ),
    );
  }
}
