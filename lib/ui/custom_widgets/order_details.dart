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
  bool hasPending = false;

  @override
  void initState() {
    super.initState();
    items = widget.order.items;
    hasPending = false;

    if (widget.hasNewItems) {
      showToast("New item(s) added to the order!");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.updateFlag(false);
      });
    }

    void updateItems(List<OrderItem> updatedItems) {
      setState(() {
        for (var updatedItem in updatedItems) {
          final updatedItemIndex = updatedItems.indexOf(updatedItem);

          if (items.elementAtOrNull(updatedItemIndex) != null) {
            if (items[updatedItemIndex].status == "ordering" &&
                updatedItem.status == "pending") {
              items[updatedItemIndex] = updatedItem;
              showToast("New item(s) added to the order!");
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

  void triggerItemsList() {
    items.removeAt(1);
  }

  @override
  void dispose() {
    _orderSubscription.cancel();
    super.dispose();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tableNumber = widget.order.tableNumber;

    final pendingItems =
        items.where((item) => item.status == 'pending').toList();
    final inProgressItems =
        items.where((item) => item.status == 'in progress').toList();
    final servedItems = items.where((item) => item.status == 'served').toList();

    if (pendingItems.isNotEmpty) hasPending = true;

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
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (pendingItems.isNotEmpty)
                  ExpansionTile(
                    childrenPadding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                    title: const Text(
                      'Pending Items',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    initiallyExpanded: true,
                    children: pendingItems.map((item) {
                      return ItemDetails(item: item);
                    }).toList(),
                  ),
                if (inProgressItems.isNotEmpty)
                  ExpansionTile(
                    title: const Text(
                      'In Progress',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    initiallyExpanded: widget.order.status == "in progress",
                    children: inProgressItems
                        .asMap()
                        .map((index, item) {
                          final uniqueKey = Key('${item.itemId}_$index');
                          final childWidget = widget.order.status ==
                                  'in progress'
                              ? Dismissible(
                                  key: uniqueKey,
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (direction) {},
                                  confirmDismiss: (direction) async {
                                    setState(() {
                                      int originalIndex = items.indexOf(item);
                                      _orderService.updateItemStatus(
                                          widget.orderId,
                                          item.itemId,
                                          "served",
                                          originalIndex);
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
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  child: ItemDetails(item: item),
                                )
                              : ItemDetails(item: item);
                          return MapEntry(
                              index,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: childWidget,
                              ));
                        })
                        .values
                        .toList(),
                  ),
                if (servedItems.isNotEmpty)
                  ExpansionTile(
                    title: const Text(
                      'Served Items',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    initiallyExpanded: widget.order.status == "served",
                    children: servedItems
                        .asMap()
                        .map((index, item) {
                          final uniqueKey = Key('${item.itemId}_$index');
                          final childWidget = widget.order.status ==
                                  'in progress'
                              ? Dismissible(
                                  key: uniqueKey,
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {},
                                  confirmDismiss: (direction) async {
                                    setState(() {
                                      int originalIndex = items.indexOf(item);
                                      _orderService.updateItemStatus(
                                          widget.orderId,
                                          item.itemId,
                                          "in progress",
                                          originalIndex);
                                      item.status = 'in progress';
                                    });
                                    return false;
                                  },
                                  background: Card(
                                    color: const Color(0xffFED9E1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      margin: const EdgeInsets.all(20),
                                      child: const Text(
                                        'Undo',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  child: ItemDetails(item: item),
                                )
                              : ItemDetails(item: item);
                          return MapEntry(
                              index,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: childWidget,
                              ));
                        })
                        .values
                        .toList(),
                  )
              ],
            ),
          ),
          if (widget.order.status == "served")
            Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total: EGP ${widget.order.totalBill}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Paid: EGP ${widget.order.paidSoFar}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ])),
          if (!hasPending || widget.order.status == "pending")
            StatusButton(
              orderStatus: widget.order.status,
              updateStatus: widget.updateStatus,
            )
        ],
      ),
    );
  }
}
