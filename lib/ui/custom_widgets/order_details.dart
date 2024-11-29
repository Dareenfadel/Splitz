import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splitz/ui/custom_widgets/item_details.dart';
import '../../constants/app_colors.dart';
import 'status_button.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final String orderId;
  final Function(String) updateStatus;

  OrderDetailsPage(
      {required this.orderData,
      required this.orderId,
      required this.updateStatus});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late List<dynamic> items;

  @override
  void initState() {
    super.initState();
    items = widget.orderData['items'];
  }

  _updateItemStatusInFirestore(String itemID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference orderRef =
        firestore.collection('orders').doc(widget.orderId);

    List<Map<String, dynamic>> updatedItems = List.from(items);
    for (var item in updatedItems) {
      if (item['item_id'] == itemID) {
        item['prepared'] = true;
      }
    }
    await orderRef.update({'items': updatedItems});
  }

  @override
  Widget build(BuildContext context) {
    final tableNumber = widget.orderData['table_number'];

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
                return item['prepared'] == false &&
                        widget.orderData['status'] == 'in progress'
                    ? Dismissible(
                        key: Key(item['item_id']),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {},
                        confirmDismiss: (direction) async {
                          setState(() {
                            _updateItemStatusInFirestore(item['item_id']);
                          });
                          return true;
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
          if (widget.orderData['status'] == "served")
            Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total: ${widget.orderData['total_bill']} EGP',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        (widget.orderData['paid_amount'] == null
                            ? 'Paid: 0 EGP'
                            : 'Paid: ${widget.orderData['paid_amount']} EGP'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ])),
          StatusButton(
            orderStatus: widget.orderData['status'],
            updateStatus: widget.updateStatus,
          ),
        ],
      ),
    );
  }
}
