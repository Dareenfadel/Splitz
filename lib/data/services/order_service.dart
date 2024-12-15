import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/order_item_user.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/menu_item_service.dart';
import 'package:splitz/data/services/notifications_service.dart';
import 'package:splitz/data/services/users_service.dart';

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

  /// Fetch orders by client using orderIds from UserModel
  Future<List<Order>> fetchOrdersByClient(UserModel user) async {
    try {
      if (user.orderIds.isEmpty) {
        return [];
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where(FieldPath.documentId, whereIn: user.orderIds)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Order.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders by client: $e');
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

  /// Fetch a specific order by ID and listen to real-time updates
  Stream<(Order, Map<String, UserModel>)> listenToOrderAndItsUsersByOrderId(
    String orderId,
  ) {
    try {
      return _firestore
          .collection('orders')
          .doc(orderId)
          .snapshots()
          .map((doc) {
        if (!doc.exists) {
          throw Exception('Order not found');
        }

        var order = Order.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );

        _validateOrder(order);
        return order;
      }).asyncMap((order) async {
        var orderUsersMap =
            await UsersService().fetchUsersByIds(order.userIds.toSet());

        return (order, orderUsersMap);
      });
    } catch (e) {
      throw Exception('Failed to listen to order: $e');
    }
  }

  _validateOrder(Order order) {
    for (var item in order.items) {
      if (item.userList.isEmpty) {
        throw Exception(
            'Invalid Order In Database: Item ${item.itemId} has no users associated with it. Order ID: ${order.orderId}');
      }
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
              .map((doc) => Order.fromFirestore(doc.id, doc.data()))
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

  Future<void> checkAndAddUserToOrder({
    required String restaurantId,
    required String tableNumber,
  }) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Query to find orders that match the restaurant and table number
        QuerySnapshot querySnapshot = await _firestore
            .collection('orders')
            .where('restaurant_id', isEqualTo: restaurantId)
            .where('table_number', isEqualTo: tableNumber)
            .where('paid', isEqualTo: false)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Order exists, now check if the user is already in the user list
          DocumentSnapshot orderDoc = querySnapshot.docs.first;
          Order order = Order.fromFirestore(
              orderDoc.id, orderDoc.data() as Map<String, dynamic>);

          if (!order.userIds.contains(userId)) {
            // Add the user to the list if not already present
            order.userIds.add(userId);

            // Update the order with the new user list
            await orderDoc.reference.update({
              'user_ids': order.userIds,
            });
            print('User added to the existing order');
          } else {
            print('User already exists in the order');
          }

          // Either user was already in the order or has been added now,
          // update the user's current order ID, the list of order IDs will
          // not add the same order ID multiple times so it is safe to call.
          await _updateUserOrderIds(userId, orderDoc.id);
        } else {
          // No existing order, create a new one
          String orderId =
              _firestore.collection('orders').doc().id; // Generate new order ID

          // Create the new order in Firestore
          await _firestore.collection('orders').doc(orderId).set({
            'date': DateTime.now().toIso8601String().split('T').first,
            'restaurant_id': restaurantId,
            'order_id': orderId,
            'status': 'ordering',
            'table_number': tableNumber,
            'total_bill': 0.0,
            'paid_so_far': 0.0,
            'paid': false,
            'items': [],
            'user_ids': [userId],
          });
          await _updateUserOrderIds(userId, orderId);
          print('New order created and user added');
        }
      } else {
        print('User not signed in');
      }
    } catch (e) {
      print('Error in checking or adding user to order: $e');
    }
  }

  // Listen to real-time updates for orders that contain the current user in user_ids
  Stream<List<Order>> listenToOrdersByUserId() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    print("user id is ${user!.uid}");
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .switchMap((userDoc) {
      if (!userDoc.exists) return Stream.value([]);
      print(userDoc.data());
      String? currentOrderId = userDoc.get('currentOrderId') as String?;
      print("current order id is $currentOrderId");
      if (currentOrderId == null) return Stream.value([]);

      return _firestore
          .collection('orders')
          .where('order_id', isEqualTo: currentOrderId)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => Order.fromFirestore(doc.id, doc.data()))
              .toList());
    });
  }

  Future<void> _updateUserOrderIds(String userId, String orderId) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        UserModel user =
            UserModel.fromMap(userDoc.data() as Map<String, dynamic>, userId);

        if (user.currentOrderId != orderId) {
          user.currentOrderId = orderId;
        }

        if (!user.orderIds.contains(orderId)) {
          user.orderIds.add(orderId);
        }
        await userRef.update({
          'currentOrderId': user.currentOrderId,
          'orderIds': user.orderIds,
        });
        print('User document updated with new order ID');
      } else {
        print('User document not found');
      }
    } catch (e) {
      print('Error updating user orderIds: $e');
    }
  }

  Future<void> addItemToOrder(String userId, OrderItem item) async {
    try {
      // Get the user's current order ID
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      String? orderId = userDoc.get('currentOrderId') as String?;

      DocumentReference orderRef = _firestore.collection('orders').doc(orderId);

      // Get current items array
      DocumentSnapshot orderDoc = await orderRef.get();
      List<dynamic> currentItems = orderDoc.get('items') ?? [];

      // Add new item
      currentItems.add(item.toMap());

      // Update order document
      await orderRef.update({
        'items': currentItems,
      });
    } catch (e) {
      throw Exception('Failed to add item to order: $e');
    }
  }

  Future<void> updateItemInOrder(
      String orderId, OrderItem updatedItem, int orderItemInd) async {
    try {
      DocumentReference orderRef = _firestore.collection('orders').doc(orderId);
      DocumentSnapshot orderDoc = await orderRef.get();

      if (!orderDoc.exists) {
        throw Exception('Order not found');
      }

      List<dynamic> items = orderDoc.get('items') ?? [];
      int itemIndex = orderItemInd;

      if (itemIndex != -1) {
        items[itemIndex] = updatedItem.toMap();
        await orderRef.update({'items': items});
      } else {
        throw Exception('Item not found in order');
      }
    } catch (e) {
      throw Exception('Failed to update item in order: $e');
    }
  }

  Future<OrderItem> getOrderItemDetails(
      String orderId, int orderItemInd) async {
    try {
      DocumentSnapshot orderDoc =
          await _firestore.collection('orders').doc(orderId).get();
      if (!orderDoc.exists) {
        throw Exception('Order not found');
      }

      List<dynamic> items = orderDoc.get('items') ?? [];
      if (orderItemInd < 0 || orderItemInd >= items.length) {
        throw Exception('Invalid item index');
      }

      return OrderItem.fromFirestore(items[orderItemInd]);
    } catch (e) {
      throw Exception('Failed to get order item details: $e');
    }
  }

  Future<void> unsetCurrentOrderForUserId(String userId) {
    return _firestore.collection('users').doc(userId).update({
      'currentOrderId': null,
    });
  }

  Future<void> _updateOrderWithTransaction({
    required String orderId,
    required Function(Order) updateFunction,
  }) {
    return _firestore.runTransaction((transaction) async {
      var orderRef = _firestore.collection('orders').doc(orderId);
      var orderSnapshot = await transaction.get(orderRef);

      if (!orderSnapshot.exists) {
        throw Exception('Order not found');
      }

      var order = Order.fromFirestore(
        orderSnapshot.id,
        orderSnapshot.data()!,
      );

      updateFunction(order);

      var newOrder = order.toMap();
      transaction.update(orderRef, newOrder);
    });
  }

  Future<void> sendSplitAllEquallyRequest({
    required String orderId,
    required String requestorUserId,
  }) async {
    await _updateOrderWithTransaction(
      orderId: orderId,
      updateFunction: (order) {
        order.splitEquallyPendingUserIds = order.nonPaidUserIds
            .where((userId) => userId != requestorUserId)
            .toList();
      },
    );

    await NotificationsService.sendSplittingEquallyRequestNotification(
      orderId: orderId,
      requestedByUserId: requestorUserId,
    );
  }

  Future<void> acceptSplitAllEquallyRequest({
    required String orderId,
    required String acceptingUserId,
  }) async {
    await _updateOrderWithTransaction(
        orderId: orderId,
        updateFunction: (order) {
          order.splitEquallyPendingUserIds.remove(acceptingUserId);

          if (order.splitEquallyPendingUserIds.isEmpty) {
            for (var item in order.nonOrderingItems) {
              for (var userId in order.nonPaidUserIds) {
                var existingRequests =
                    item.userList.where((user) => user.userId == userId);

                if (existingRequests.isNotEmpty) {
                  existingRequests.first.requestStatus = 'accepted';
                } else {
                  item.userList.add(OrderItemUser(
                    userId: userId,
                    requestStatus: 'accepted',
                  ));
                }
              }
            }
          }
        });

    await NotificationsService.sendAcceptSplittingEquallyRequestNotification(
      orderId: orderId,
      acceptingUserId: acceptingUserId,
    );
  }

  Future<void> rejectSplitAllEquallyRequest({
    required String orderId,
    required String rejectingUserId,
  }) async {
    await _updateOrderWithTransaction(
      orderId: orderId,
      updateFunction: (order) {
        order.splitEquallyPendingUserIds = [];
      },
    );

    await NotificationsService.sendRejectSplittingEquallyRequestNotification(
      orderId: orderId,
      rejectingUserId: rejectingUserId,
    );
  }

  checkoutCart(String orderId) {
    return _updateOrderWithTransaction(
      orderId: orderId,
      updateFunction: (order) {
        for (var item in order.items) {
          item.status = 'pending';
        }

        order.totalBill = order.calculatedTotalBill;
      },
    );
  }

  removeCartItem({required String orderId, required int itemIndex}) {
    return _updateOrderWithTransaction(
      orderId: orderId,
      updateFunction: (order) {
        order.items.removeAt(itemIndex);
      },
    );
  }

  Stream<bool> listenToUserPaymentStatus({
    required String orderId,
    required userId,
  }) {
    return listenToOrderAndItsUsersByOrderId(orderId).map((data) {
      var (order, orderUsersMap) = data;

      return order.userPaid(userId);
    });
  }

  Future<void> duplicateOrderItem({
    required String orderId,
    required int itemIndex,
  }) {
    return _updateOrderWithTransaction(
      orderId: orderId,
      updateFunction: (order) {
        var itemToDuplicate = order.items[itemIndex];
        var duplicateItem = itemToDuplicate.copyWith();

        // Insert after the original item and shift the rest
        order.items.insert(itemIndex + 1, duplicateItem);
      },
    );
  }
}
