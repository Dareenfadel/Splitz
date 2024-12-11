import '../models/order_item.dart';
import '../models/order_item_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/order_service.dart';

class OrderItemService {
  OrderItemService._();
  static final OrderItemService _instance = OrderItemService._();
  factory OrderItemService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final OrderService _orderService = OrderService();

  // get order items details by id
  Future<OrderItem?> getOrderItemById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('orderItems').doc(id).get();
      if (doc.exists) {
        return OrderItem.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting order item: $e');
      return null;
    }
  }

  Stream<(OrderItem, Map<String, UserModel>)> listenToOrderItemAndItsUsers({
    required String orderId,
    required int itemIndex,
  }) {
    return _orderService.listenToOrderAndItsUsersByOrderId(orderId).map((data) {
      var (order, orderUsersMap) = data;
      return (order.items[itemIndex], orderUsersMap);
    });
  }

  Future<void> updateOrderItem({
    required String orderId,
    required int itemIndex,
    required Function(OrderItem) updateFunction,
  }) async {
    return _firestore.runTransaction((transaction) async {
      var orderRef = _firestore.collection('orders').doc(orderId);
      var orderSnapshot = await transaction.get(orderRef);

      if (!orderSnapshot.exists) {
        throw Exception('Order not found');
      }

      var order = Order.fromFirestore(
        orderSnapshot.id,
        orderSnapshot.data() as Map<String, dynamic>,
      );

      if (itemIndex >= order.items.length) {
        throw Exception('Invalid item index');
      }

      updateFunction(order.items[itemIndex]);

      var orderMap = order.toMap();
      transaction.update(orderRef, {
        'items': orderMap['items'],
      });
    });
  }

  Future<void> acceptOrderItemByUserId({
    required String orderId,
    required int itemIndex,
    required String userId,
  }) async {
    await updateOrderItem(
      orderId: orderId,
      itemIndex: itemIndex,
      updateFunction: (item) {
        var userIndex =
            item.userList.indexWhere((user) => user.userId == userId);

        if (userIndex == -1) {
          throw Exception('User not found in item');
        }

        if (item.userList[userIndex].requestStatus != 'pending') {
          throw Exception('User request status is not pending');
        }

        if (item.userList[userIndex].requestStatus == 'accepted') {
          throw Exception('User request status is already accepted');
        }

        item.userList[userIndex].requestStatus = 'accepted';
      },
    );
  }

  Future<void> rejectOrderItemByUserId({
    required String orderId,
    required int itemIndex,
    required String userId,
  }) async {
    await updateOrderItem(
      orderId: orderId,
      itemIndex: itemIndex,
      updateFunction: (item) {
        var userIndex =
            item.userList.indexWhere((user) => user.userId == userId);

        if (userIndex == -1) {
          throw Exception('User not found in item');
        }

        if (item.userList[userIndex].requestStatus != 'pending') {
          throw Exception('User request status is not pending');
        }

        item.userList.removeAt(userIndex);
      },
    );
  }

  Future<void> sendRequestToOrderItem({
    required String orderId,
    required int itemIndex,
    required String requestedToUserId,
    required String requestedByUserId,
  }) async {
    await updateOrderItem(
      orderId: orderId,
      itemIndex: itemIndex,
      updateFunction: (item) {
        if (item.userList.any((u) => u.userId == requestedToUserId)) {
          throw Exception('User already exists in item');
        }

        item.userList.add(
          OrderItemUser(
            userId: requestedToUserId,
            requestStatus: 'pending',
            requestedBy: requestedByUserId,
          ),
        );
      },
    );
  }

  Future<void> addUserToOrderItem({
    required String orderId,
    required int itemIndex,
    required String userId,
  }) async {
    await updateOrderItem(
      orderId: orderId,
      itemIndex: itemIndex,
      updateFunction: (item) {
        if (item.userList.any((u) => u.userId == userId)) {
          throw Exception('User already exists in item');
        }

        item.userList.add(
          OrderItemUser(
            userId: userId,
            requestStatus: 'accepted',
            requestedBy: userId,
          ),
        );
      },
    );
  }

  Future<void> removeUserFromOrderItem({
    required String orderId,
    required int itemIndex,
    required String userId,
  }) async {
    await updateOrderItem(
      orderId: orderId,
      itemIndex: itemIndex,
      updateFunction: (item) {
        var userIndex = item.userList.indexWhere((u) => u.userId == userId);

        if (userIndex == -1) {
          throw Exception('User not found in item');
        }

        item.userList.removeAt(userIndex);
      },
    );
  }
}
