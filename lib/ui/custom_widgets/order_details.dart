import 'package:flutter/material.dart';
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

  OrderDetailsPage(
      {required this.order, required this.orderId, required this.updateStatus});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late List<OrderItem> items;
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    items = widget.order.items;
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
                return item.prepared == false &&
                        widget.order.status == 'in progress'
                    ? Dismissible(
                        key: Key(item.itemId),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {},
                        confirmDismiss: (direction) async {
                          setState(() {
                            _orderService.updateItemStatus(
                                widget.orderId, item.itemId);
                            item.prepared = true;
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
                              'Prepared',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                        child: ItemDetails(item: item),
                      )
                    : ItemDetails(item: item);
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
