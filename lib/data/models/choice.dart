class Choice {
  final String id;
  final String name;
  final double price;

  Choice({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Choice.fromFirestore(Map<String, dynamic> firestore) {
    return Choice(
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
