import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

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
                          return true; // Allow dismissal
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
                        child: Card(
                          color: item['prepared']
                              ? AppColors.secondary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: AppColors.secondary,
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: item['image_url'] != null &&
                                      item['image_url'].isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(item['image_url'],
                                          fit: BoxFit.cover),
                                    )
                                  : const Icon(Icons.image_not_supported,
                                      color: Colors.grey, size: 30),
                            ),
                            title: Text(
                              item['item_name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 73, 72, 72),
                                fontWeight: FontWeight.normal,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item['notes'] != null)
                                    Text('Notes: ${item['notes']}'),
                                  if (item['extras'] != null &&
                                      item['extras'] is List &&
                                      item['extras'].isNotEmpty)
                                    Wrap(
                                      children: [
                                        const Text("Extras: "),
                                        ...item['extras']
                                            .asMap()
                                            .entries
                                            .map<Widget>((entry) {
                                          int index = entry.key;
                                          var extra = entry.value;
                                          bool isLast = index ==
                                              item['extras'].length - 1;
                                          return Text(
                                            '${extra['name']} (x${extra['quantity'] ?? 1})${isLast ? '' : ' , '}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          );
                                        }).toList(),
                                      ],
                                    )
                                ],
                              ),
                            ),
                            trailing: Text(
                              'x${item['quantity']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    : Card(
                        color: item['prepared']
                            ? AppColors.secondary
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: AppColors.secondary,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: item['image_url'] != null &&
                                    item['image_url'].isNotEmpty
                                ? ClipOval(
                                    child: Image.network(item['image_url'],
                                        fit: BoxFit.cover),
                                  )
                                : const Icon(Icons.image_not_supported,
                                    color: Colors.grey, size: 30),
                          ),
                          title: Text(
                            item['item_name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 73, 72, 72),
                              fontWeight: FontWeight.normal,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item['notes'] != null)
                                  Text('Notes: ${item['notes']}'),
                                if (item['extras'] != null &&
                                    item['extras'] is List &&
                                    item['extras'].isNotEmpty)
                                  Wrap(
                                    children: [
                                      const Text("Extras: "),
                                      ...item['extras']
                                          .asMap()
                                          .entries
                                          .map<Widget>((entry) {
                                        int index = entry.key;
                                        var extra = entry.value;
                                        bool isLast =
                                            index == item['extras'].length - 1;
                                        return Text(
                                          '${extra['name']} (x${extra['quantity'] ?? 1})${isLast ? '' : ' , '}',
                                          style: const TextStyle(fontSize: 15),
                                        );
                                      }).toList(),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          trailing: Text(
                            'x${item['quantity']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
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
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Container(
              width: 180,
              child: FloatingActionButton(
                onPressed: () => {
                  widget.updateStatus(widget.orderData['status'] == "pending"
                      ? "in progress"
                      : widget.orderData['status'] == "in progress"
                          ? "served"
                          : "paid"),
                  Navigator.pop(context)
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 3,
                child: Text(
                  getOrderStatusText(widget.orderData['status']),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
