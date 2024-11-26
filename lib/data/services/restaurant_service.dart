//made for test cases
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new restaurant with default attributes
  Future<void> createRestaurant({
    required String name,
    required String image,
  }) async {
    try {
      // Create a new restaurant document in Firestore
      await _db.collection('restaurants').add({
        'name': name,
        'overall_rating': 0.0, // Default rating
        'image': image,
      });

      print('Restaurant "$name" created successfully.');
    } catch (e) {
      print('Error creating restaurant: $e');
    }
  }
}
