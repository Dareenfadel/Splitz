import 'package:splitz/data/models/order_item_user.dart';
import 'package:splitz/data/models/order_item_type.dart';

class OrderItem {
  final String itemId;
  final String itemName;
  final String imageUrl;
  final int quantity;
  final Map<String, int> extras;
  final String notes;
  final double paidAmount;
  final double price;
  final Map<String, double> paidUsers;
  final List<OrderItemUser> userList;
  bool prepared;
  final String status;
  final Map<String, String> options;

  OrderItem({
    required this.itemId,
    required this.itemName,
    required this.imageUrl,
    required this.quantity,
    required this.extras,
    required this.notes,
    required this.paidAmount,
    required this.paidUsers,
    required this.prepared,
    required this.price,
    required this.userList,
    required this.status,
    required this.options,
  });

  bool isSharedWithUser(String userId) {
    return userList.any((user) => user.userId == userId);
  }

  bool isPendingForUser(String userId) {
    return userList.any(
        (user) => user.userId == userId && user.requestStatus == 'pending');
  }

  bool isAcceptedForUser(String userId) {
    return userList.any(
        (user) => user.userId == userId && user.requestStatus == 'accepted');
  }

  // Get the user id of the user who requested this item from the user with the given id
  String? getRequestingUserIdFor(String userId) {
    return userList.firstWhere((user) => user.userId == userId).requestedBy;
  }

  OrderItemType itemTypeForUserId(String userId) {
    if (isAcceptedForUser(userId)) {
      return OrderItemType.myItem;
    } else if (isPendingForUser(userId)) {
      return OrderItemType.request;
    } else {
      return OrderItemType.otherPeopleItem;
    }
  }

  double get sharePrice => price / userList.length;

  factory OrderItem.fromFirestore(Map<String, dynamic> firestore) {
    return OrderItem(
      itemId: firestore['item_id'],
      itemName: firestore['item_name'],
      imageUrl: firestore['image_url'],
      quantity: firestore['quantity'],
      extras: Map<String, int>.from(firestore['extras'] ?? []),
      notes: firestore['notes'] ?? '',
      paidAmount: (firestore['paid_amount'] ?? 0).toDouble(),
      paidUsers: Map<String, double>.from(firestore['paid_users'] ?? {}),
      prepared: firestore['prepared'] ?? false,
      price: (firestore['price'] ?? 0).toDouble(),
      userList: (firestore['user_list'] as List<dynamic>?)
              ?.map((user) => OrderItemUser.fromFirestore(user))
              .toList() ??
          [],
      status: firestore['status'] ?? 'oredering',
      options: Map<String, String>.from(firestore['options'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_id': itemId,
      'item_name': itemName,
      'image_url': imageUrl,
      'quantity': quantity,
      'extras': extras,
      'notes': notes,
      'paid_amount': paidAmount,
      'paid_users': paidUsers,
      'prepared': prepared,
      'price': price,
      'user_list': userList.map((user) => user.toMap()).toList(),
      'status': status,
      'options': options,
    };
  }
}
