class MenuCategory {
  final String name;
  final String description;
  final String image;
  final List<String> itemIds; // List of menu item references (IDs)

  MenuCategory({
    required this.name,
    required this.description,
    required this.image,
    required this.itemIds,
  });

  factory MenuCategory.fromFirestore(Map<String, dynamic> firestore) {
    return MenuCategory(
      name: firestore['name']??'',
      description: firestore['description']??'',
      image: firestore['image']??'',
      itemIds: List<String>.from(firestore['item_ids']??[]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'item_ids': itemIds,
    };
  }
}
