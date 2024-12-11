import 'package:cloud_firestore/cloud_firestore.dart';

class MenuCategory {
  String? id;
  final String name;
  final String description;
  final String image;
  final List<String> itemIds; // List of menu item references (IDs)

  MenuCategory({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.itemIds,
  });

  factory MenuCategory.fromFirestore(DocumentSnapshot doc) {
    final firestore = doc.data() as Map<String, dynamic>;

    return MenuCategory(
      id: doc.id,
      name: firestore['name'],
      description: firestore['description'],
      image: firestore['image'],
      itemIds: List<String>.from(firestore['item_ids'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'item_ids': itemIds,
    };
  }
}
