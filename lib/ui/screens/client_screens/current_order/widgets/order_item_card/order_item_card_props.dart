// ignore: camel_case_types
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

// ignore: camel_case_types
class OrderItemCardProps_User {
  final String id;
  final String name;
  final String? imageUrl;

  OrderItemCardProps_User({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory OrderItemCardProps_User.fromUserModel(UserModel user) {
    return OrderItemCardProps_User(
      id: user.uid,
      name: user.name ?? 'Unknown',
      imageUrl: user.imageUrl,
    );
  }
}

// ignore: camel_case_types
class OrderItemCardProps_SharedWithUser extends OrderItemCardProps_User {
  final bool pendingApproval;

  OrderItemCardProps_SharedWithUser({
    required super.id,
    required super.name,
    super.imageUrl,
    required this.pendingApproval,
  });

  factory OrderItemCardProps_SharedWithUser.fromUserModel({
    required user,
    required pendingApproval,
  }) {
    return OrderItemCardProps_SharedWithUser(
      id: user.uid,
      name: user.name ?? 'Unknown',
      imageUrl: user.imageUrl,
      pendingApproval: pendingApproval,
    );
  }
}

// ignore: camel_case_types
class OrderItemCardProps_Item {
  final String id;
  final String title;
  final String notes;
  final String imageUrl;
  final double totalPrice;
  final double sharePrice;
  final List<OrderItemCardProps_SharedWithUser> sharedWith;

  OrderItemCardProps_Item({
    required this.id,
    required this.title,
    required this.notes,
    required this.imageUrl,
    required this.totalPrice,
    required this.sharePrice,
    this.sharedWith = const [],
  });

  factory OrderItemCardProps_Item.fromOrderItem({
    required OrderItem item,
    required Map<String, UserModel> usersMap,
  }) {
    return OrderItemCardProps_Item(
      id: item.itemId,
      title: item.itemName,
      notes: item.notes,
      imageUrl: item.imageUrl,
      totalPrice: item.price,
      sharePrice: item.sharePrice,
      sharedWith: item.userList
          .map(
            (user) => OrderItemCardProps_SharedWithUser.fromUserModel(
              user: usersMap[user.userId]!,
              pendingApproval: user.requestStatus == 'pending',
            ),
          )
          .toList(),
    );
  }
}
