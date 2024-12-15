import 'package:splitz/data/models/order_item.dart';

class Order {
  final String orderId;
  final String restaurantId;
  String status;
  final String tableNumber;
  double totalBill;
  double paidSoFar;
  bool paid;
  final List<OrderItem> items;
  final List<String> userIds;
  final String date;

  List<String> splitEquallyPendingUserIds;
  final List<String> paidUsers;

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
    this.splitEquallyPendingUserIds = const [],
    this.paidUsers = const [],
  });

  List<OrderItem> get nonOrderingItems =>
      items.where((item) => item.status != 'ordering').toList();

  List<OrderItem> acceptedItemsForUserId(String userId) {
    return nonOrderingItems
        .where((item) => item.userList.any((user) =>
            user.userId == userId && user.requestStatus == 'accepted'))
        .toList();
  }

  List<OrderItem> cartItemsForUserId(String uid) {
    return items
        .where((item) =>
            item.userList.any((user) => user.userId == uid) &&
            item.status == 'ordering')
        .toList();
  }

  double cartTotalForUserId(String uid) {
    return cartItemsForUserId(uid)
        .map((item) => item.sharePrice)
        .fold(0, (prev, price) => prev + price);
  }

  List<OrderItem> pendingItemsForUserId(String userId) {
    return nonOrderingItems
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
    return nonOrderingItems
        .any((item) => item.userList.any((user) => user.userId == userId));
  }

  bool userPaid(String userId) {
    return paidUsers.contains(userId);
  }

  double get calculatedPaidSoFar =>
      nonOrderingItems.fold(0, (prev, item) => prev + item.paidAmount);
  double get calculatedTotalBill =>
      nonOrderingItems.fold(0, (prev, item) => prev + item.price);

  bool get isFullyPaid => calculatedTotalBill == calculatedPaidSoFar;

  List<String> get nonPaidUserIds =>
      userIds.where((userId) => !paidUsers.contains(userId)).toList();

  get splitEquallyPrice => calculatedTotalBill / nonPaidUserIds.length;

  bool userAcceptedSplitEquallyRequest(String userId) =>
      !splitEquallyPendingUserIds.contains(userId);

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
      date: firestore['date'] ?? '',
      splitEquallyPendingUserIds:
          List<String>.from(firestore['split_equally_pending_user_ids'] ?? []),
      paidUsers: List<String>.from(firestore['paid_users'] ?? []),
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
      'split_equally_pending_user_ids': splitEquallyPendingUserIds,
      'paid_users': paidUsers,
    };
  }
}
