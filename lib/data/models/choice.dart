import 'package:cloud_firestore/cloud_firestore.dart';

class Choice {
  String? id;
  final String name;
  final double price;

  Choice({
    this.id,
    required this.name,
    required this.price,
  });

  factory Choice.fromFirestore(DocumentSnapshot doc) {
    final firestore = doc.data() as Map<String, dynamic>;
    return Choice(
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
