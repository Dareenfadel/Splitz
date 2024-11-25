class UserModel {
  final String uid;
  final String userType;
  final String? restaurantId;
  final List<String> orderIds;
  final String? name;
  UserModel({
    required this.uid,
    required this.userType,
    this.restaurantId,
    required this.orderIds,
    this.name,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      userType: data['user_type'],
      restaurantId: data['restaurant_id'],
      orderIds: List<String>.from(data['order_ids'] ?? []),
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'user_type': userType,
      'restaurant_id': restaurantId,
      'order_ids': orderIds,
      'name': name,
    };
  }
}
