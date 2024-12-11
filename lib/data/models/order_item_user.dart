class OrderItemUser {
  final String userId;
  final String? requestedBy; // Nullable for the original requester
  final String requestStatus; // Values: 'pending', 'accepted'

  OrderItemUser({
    required this.userId,
    this.requestedBy,
    required this.requestStatus,
  });

  factory OrderItemUser.fromFirestore(Map<String, dynamic> firestore) {
    return OrderItemUser(
      userId: firestore['user_id'],
      requestedBy: firestore['requested_by'],
      requestStatus: firestore['request_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'requested_by': requestedBy,
      'request_status': requestStatus,
    };
  }
}