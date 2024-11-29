import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';

class OrderService {
  //Private constructor
  OrderService._();

  // The single instance of the class
  static final OrderService _instance = OrderService._();

  // Factory method to access the instance
  factory OrderService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all orders for a specific restaurant
  Future<List<Order>> fetchOrdersByRestaurant(String restaurantId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('restaurant_id', isEqualTo: restaurantId)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Order.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Fetch a specific order by ID
  Future<Order?> fetchOrderById(String orderId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('orders').doc(orderId).get();

      if (doc.exists) {
        return Order.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  /// Create a new order
  Future<void> createOrder(Order order) async {
    try {
      await _firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toMap());
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Update an existing order
  Future<void> updateOrder(Order order) async {
    try {
      await _firestore
          .collection('orders')
          .doc(order.orderId)
          .update(order.toMap());
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  /// Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  /// Listen to real-time updates for a specific restaurant's orders
  Stream<List<Order>> listenToOrdersByRestaurant(String restaurantId) {
    try {
      return _firestore
          .collection('orders')
          .where('restaurant_id', isEqualTo: restaurantId)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => Order.fromFirestore(
                  doc.id, doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      throw Exception('Failed to listen to orders: $e');
    }
  }

  Future<void> updateItemStatus(String orderId, String itemID) async {
    try {
      DocumentReference orderRef = _firestore.collection('orders').doc(orderId);
      DocumentSnapshot orderSnapshot = await orderRef.get();

      if (orderSnapshot.exists) {
        Order order = Order.fromFirestore(
            orderSnapshot.id, orderSnapshot.data() as Map<String, dynamic>);

        // Update item status
        for (var item in order.items) {
          if (item.itemId == itemID) {
            item.prepared = true;
          }
        }

        // Update Firestore with modified items
        await orderRef.update({
          'items': order.items.map((item) => item.toMap()).toList(),
        });
        print('Item status updated to prepared');
      } else {
        print('Order not found');
      }
    } catch (e) {
      print('Error updating item status: $e');
    }
  }

  // Update the overall order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      DocumentReference orderRef =
          FirebaseFirestore.instance.collection('orders').doc(orderId);

      if (newStatus == "served") {
        DocumentSnapshot orderSnapshot = await orderRef.get();

        if (orderSnapshot.exists) {
          // Convert the 'items' field to a List<OrderItem>
          List<dynamic> itemsData = orderSnapshot['items'];
          List<OrderItem> items = itemsData.map((item) {
            return OrderItem.fromFirestore(item as Map<String, dynamic>);
          }).toList();

          // Mark items as prepared
          for (var item in items) {
            item.prepared = true;
          }
          await orderRef.update({
            'status': newStatus,
            'items': items.map((item) => item.toMap()).toList(),
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

  // Fetch orders by restaurant ID and status
  Stream<List<Order>> fetchOrders(String restaurantId, String orderStatus) {
    return _firestore
        .collection('orders')
        .where('restaurant_id', isEqualTo: restaurantId)
        .where('status', isEqualTo: orderStatus.toLowerCase())
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Order.fromFirestore(doc.id, doc.data()))
            .toList());
  }
}
