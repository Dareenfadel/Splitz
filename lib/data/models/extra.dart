import 'package:cloud_firestore/cloud_firestore.dart';

class Extra {
  String? id;
  final String name;
  final double price;

  Extra({
    this.id,
    required this.name,
    required this.price,
  });

  factory Extra.fromFirestore(DocumentSnapshot doc) {
    final firestore = doc.data() as Map<String, dynamic>;

    final id = doc.id;
    final name = firestore['name'] ?? 'Unnamed Extra';
    final price = (firestore['price'] as num?)?.toDouble() ?? 0.0;

    return Extra(
      id: id,
      name: name,
      price: price,
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
