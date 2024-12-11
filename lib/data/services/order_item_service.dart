import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_item.dart';
import '../models/order_item_user.dart';

class OrderItemService {
  // Private constructor
  OrderItemService._();

  // The single instance of the class
  static final OrderItemService _instance = OrderItemService._();

  // Factory method to access the instance
  factory OrderItemService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//get order items details by id
Future<OrderItem?> getOrderItemById(String id) async {
  try {
    DocumentSnapshot doc = await _firestore.collection('orderItems').doc(id).get();
    if (doc.exists) {
      return OrderItem.fromFirestore(doc.data() as Map<String, dynamic>);
    }
    return null;
  } catch (e) {
    print('Error getting order item: $e');
    return null;
  }
}
// 
}