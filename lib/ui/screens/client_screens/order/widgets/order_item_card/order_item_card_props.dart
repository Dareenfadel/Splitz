
// ignore: camel_case_types
class OrderItemCardProps_User {
  final String id;
  final String name;
  final String imageUrl;

  OrderItemCardProps_User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

// ignore: camel_case_types
class OrderItemCardProps_SharedWithUser extends OrderItemCardProps_User {
  final bool pendingApproval;

  OrderItemCardProps_SharedWithUser({
    required super.id,
    required super.name,
    required super.imageUrl,
    required this.pendingApproval,
  });
}

class OrderItemCardProps_Item {
  final String title;
  final String notes;
  final String imageUrl;
  final double totalPrice;
  final double sharePrice;
  final List<OrderItemCardProps_SharedWithUser> sharedWith;

  OrderItemCardProps_Item({
    required this.title,
    required this.notes,
    required this.imageUrl,
    required this.totalPrice,
    required this.sharePrice,
    this.sharedWith = const [],
  });
}
