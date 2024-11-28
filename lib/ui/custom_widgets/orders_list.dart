import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_card.dart';

class OrdersList extends StatefulWidget {
  final String restaurantId;
  final String orderStatus;

  OrdersList({required this.restaurantId, required this.orderStatus});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  void updateOrderStatus(String orderId, String newStatus) async {
    try {
      DocumentReference orderRef =
          FirebaseFirestore.instance.collection('orders').doc(orderId);

      if (newStatus == "served") {
        DocumentSnapshot orderSnapshot = await orderRef.get();

        if (orderSnapshot.exists) {
          List<dynamic> items = orderSnapshot['items'];

          for (var item in items) {
            item['prepared'] = true;
          }
          await orderRef.update({
            'status': newStatus,
            'items': items,
          });

          print(
              'Order status updated to "served" and items marked as prepared');
        } else {
          print('Order not found');
        }
      } else {
        await orderRef.update({
          'status': newStatus,
        });
        print('Order status updated to $newStatus');
      }
    } catch (e) {
      print('Error updating order status in Firestore: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          // .where('restaurant_id', isEqualTo: widget.restaurantId)
          .where('status', isEqualTo: widget.orderStatus.toLowerCase())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No orders ${widget.orderStatus.toLowerCase()}',
                style: const TextStyle(fontSize: 18)),
          );
        }

        final orders = snapshot.data!.docs;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderDoc = snapshot.data!.docs[index];
            final orderData = orderDoc.data() as Map<String, dynamic>;
            return OrderCard(
              orderData: orderData,
              orderId: orderDoc.id,
              updateStatus: (newStatus) =>
                  updateOrderStatus(orderDoc.id, newStatus),
            );
          },
        );
      },
    );
  }
}
