class Extra {
  final String id;
  final String name;
  final double price;

  Extra({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Extra.fromFirestore(Map<String, dynamic> firestore) {
    return Extra(
      id: firestore['id'],
      name: firestore['name'],
      price: firestore['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
