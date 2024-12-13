import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitz/data/models/menu_category.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<MenuCategory>> fetchMenuCategories(String restaurantId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_categories')
          .get();
      return snapshot.docs.map((doc) {
        return MenuCategory.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Error fetching menu categories: $e');
      return [];
    }
  }

  Future<void> addMenuCategory(
    String restaurantId,
    String categoryName,
    String description,
    String image,
  ) async {
    try {
      DocumentReference categoryRef = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_categories')
          .add({
        'name': categoryName,
        'description': description,
        'image': image,
        'item_ids': [],
      });

      print('Category added with ID: ${categoryRef.id}');
    } catch (e) {
      print('Error adding menu category: $e');
    }
  }

  Future<MenuCategory?> fetchCategoryById(
      String restaurantId, String categoryId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_categories')
          .where(FieldPath.documentId, isEqualTo: categoryId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return MenuCategory.fromFirestore(snapshot.docs.first);
      } else {
        print('Category not found');
        return null;
      }
    } catch (e) {
      print('Error fetching category by ID: $e');
      return null;
    }
  }
}
