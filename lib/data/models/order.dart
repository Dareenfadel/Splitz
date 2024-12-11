import 'package:splitz/data/models/order_item.dart';

class Order {
  final String orderId;
  final String restaurantId;
  final String status;
  final String tableNumber;
  double totalBill;
  double paidSoFar;
  final bool paid;
  final List<OrderItem> items;
  final List<String> userIds;
  final String date;

  Order({
    required this.orderId,
    required this.restaurantId,
    required this.status,
    required this.tableNumber,
    required this.totalBill,
    required this.paidSoFar,
    required this.paid,
    required this.items,
    required this.userIds,
    required this.date,
  });

  List<OrderItem> acceptedItemsForUserId(String userId) {
    return items
        .where((item) => item.userList.any((user) =>
            user.userId == userId && user.requestStatus == 'accepted'))
        .toList();
  }

  List<OrderItem> pendingItemsForUserId(String userId) {
    return items
        .where((item) => item.userList.any(
            (user) => user.userId == userId && user.requestStatus == 'pending'))
        .toList();
  }

  double totalBillForUserId(String userId) {
    return acceptedItemsForUserId(userId)
        .map((item) => item.sharePrice)
        .fold(0, (prev, price) => prev + price);
  }

  bool userHasItems(String userId) {
    return items
        .any((item) => item.usersList.any((user) => user.userId == userId));
  }

  bool userPaid(String userId) {
    return userHasItems(userId) &&
        acceptedItemsForUserId(userId).every((item) => item.userPaid(userId));
        
  }

  factory Order.fromFirestore(String id, Map<String, dynamic> firestore) {
    return Order(
      orderId: id,
      restaurantId: firestore['restaurant_id'],
      status: firestore['status'],
      tableNumber: firestore['table_number'],
      totalBill: (firestore['total_bill'] ?? 0).toDouble(),
      paidSoFar: (firestore['paid_so_far'] ?? 0).toDouble(),
      paid: firestore['paid'] ?? false,
      items: (firestore['items'] as List)
          .map((item) => OrderItem.fromFirestore(item))
          .toList(),
      userIds: List<String>.from(firestore['user_ids'] ?? []),
      date: firestore['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'status': status,
      'table_number': tableNumber,
      'total_bill': totalBill,
      'paid_so_far': paidSoFar,
      'paid': paid,
      'items': items.map((item) => item.toMap()).toList(),
      'user_ids': userIds,
      'date': date,
    };
  }
}
