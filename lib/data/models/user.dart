class UserModel {
  final String uid;
  final String? name;
  final String userType; // 'manager' or 'client'
  final String? restaurantId; // Used if user is a manager
  final List<String> orderIds;

  UserModel({
    required this.uid,
    this.name,
    required this.userType,
    this.restaurantId,
    required this.orderIds,
  });

  // Convert UserModel to Map (Firestore store)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': userType,
      'restaurantId': restaurantId,
      'orderIds': orderIds,
    };
  }

  // Factory method to create UserModel from Firestore
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'],
      userType: data['role'],
      restaurantId: data['restaurantId'],
      orderIds: List<String>.from(data['orderIds'] ?? []),
    );
  }
}
