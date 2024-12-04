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
    return Extra(
      id: doc.id,
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
