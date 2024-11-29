class OrderItem {
  final String itemId;
  final String itemName;
  final String imageUrl;
  final int quantity;
  final Map<String, int> extras;
  final String notes;
  final double paidAmount;
  final Map<String, double> paidUsers;
  bool prepared;

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
  });

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
    };
  }
}
