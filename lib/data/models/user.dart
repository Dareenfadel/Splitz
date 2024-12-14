class UserModel {
  final String uid;
  final String? name;
  String userType; // 'manager' or 'client'
  String? restaurantId; // Used if user is a manager
  final List<String> orderIds;
  String? currentOrderId;
  final String? imageUrl;
  final String? fcmToken;

  UserModel({
    required this.uid,
    this.name,
    required this.userType,
    this.restaurantId,
    required this.orderIds,
    this.currentOrderId,
    this.imageUrl,
    this.fcmToken,
  });

  // Convert UserModel to Map (Firestore store)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': userType,
      'restaurantId': restaurantId,
      'orderIds': orderIds,
      'currentOrderId': currentOrderId,
      'imageUrl': imageUrl,
      'fcm': fcmToken,
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
      currentOrderId: data['currentOrderId'] ?? '',
      imageUrl: data['imageUrl'],
      fcmToken: data['fcm'] ?? '',
    );
  }
}
