//made for test cases
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../models/review.dart';

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
        'address': '',
      });

      print('Restaurant "$name" created successfully.');
    } catch (e) {
      print('Error creating restaurant: $e');
    }
  }

  Future<List<Restaurant>> fetchRestaurants() async {
    try {
      QuerySnapshot snapshot = await _db.collection('restaurants').get();

      // Map Firestore documents to Restaurant objects
      List<Restaurant> restaurants = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> restaurantData =
            doc.data() as Map<String, dynamic>;
        // Fetch `menu_categories` subcollection
        QuerySnapshot menuCategoriesSnapshot = await _db
            .collection('restaurants')
            .doc(doc.id)
            .collection('menu_categories')
            .get();
        List<MenuCategory> menuCategories = [];
        if (menuCategoriesSnapshot.docs.length != 0) {
          menuCategories = menuCategoriesSnapshot.docs.map((menuDoc) {
            return MenuCategory.fromFirestore(menuDoc);
          }).toList();
        }

        // Fetch `menu_items` subcollection
        QuerySnapshot menuItemsSnapshot = await _db
            .collection('restaurants')
            .doc(doc.id)
            .collection('menu_items')
            .get();
        List<MenuItemModel> menuItems = [];
        if (menuItemsSnapshot.docs.length != 0) {
          menuItems = menuItemsSnapshot.docs.map((itemDoc) {
            return MenuItemModel.fromFirestore(itemDoc);
          }).toList();
        }

        // Fetch `reviews` subcollection
        QuerySnapshot reviewsSnapshot = await _db
            .collection('restaurants')
            .doc(doc.id)
            .collection('reviews')
            .get();
        List<Review> reviews = [];
        if (reviewsSnapshot.docs.length != 0) {
          reviews = reviewsSnapshot.docs.map((reviewDoc) {
            return Review.fromFirestore(reviewDoc);
          }).toList();
        }

        // Add all data to the Restaurant object
        String name = restaurantData['name'] ?? 'Unknown';
        double overallRating =
            (restaurantData['overall_rating'] ?? 0).toDouble();
        String image = restaurantData['image'] ?? '';
        List<double> ratings = restaurantData['ratings'] != null
            ? (restaurantData['ratings'] as List<dynamic>)
                .map((rating) => rating as double)
                .toList()
            : [];
        String address = restaurantData['address'] ?? '';
        restaurants.add(
          Restaurant(
              id: doc.id,
              name: name,
              overallRating: overallRating,
              image: image,
              address: address,
            reviews: reviews,
              menuCategories: menuCategories,
              menuItems: menuItems,
              ratings: ratings),
        );
      }

      return restaurants;
    } catch (e) {
      print('Error fetching res: $e');
      return [];
    }
  }

  Future<Restaurant> fetchRestaurantById(String restaurantId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('restaurants').doc(restaurantId).get();
      Map<String, dynamic> restaurantData = doc.data() as Map<String, dynamic>;

      // Fetch `menu_categories` subcollection
      QuerySnapshot menuCategoriesSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_categories')
          .get();
      List<MenuCategory> menuCategories =
          menuCategoriesSnapshot.docs.map((menuDoc) {
        return MenuCategory.fromFirestore(menuDoc);
      }).toList();

      // Fetch `menu_items` subcollection
      QuerySnapshot menuItemsSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .get();
      List<MenuItemModel> menuItems = menuItemsSnapshot.docs.map((itemDoc) {
        return MenuItemModel.fromFirestore(itemDoc);
      }).toList();

      // Fetch `reviews` subcollection
      QuerySnapshot reviewsSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('reviews')
          .get();
      List<Review> reviews = reviewsSnapshot.docs.map((reviewDoc) {
        return Review.fromFirestore(reviewDoc);
      }).toList();

      // Create a new Restaurant object
      String name = restaurantData['name'] ?? 'Unknown';
      double overallRating = (restaurantData['overall_rating'] ?? 0).toDouble();
      String image = restaurantData['image'] ?? '';
      List<double> ratings = restaurantData['ratings'] != null
          ? (restaurantData['ratings'] as List<dynamic>)
              .map((rating) => rating as double)
              .toList()
          : [];
      String address = restaurantData['address'] ?? '';
      return Restaurant(
          id: restaurantId,
          name: name,
          overallRating: overallRating,
          image: image,
          address: address,
        reviews: reviews,
          menuCategories: menuCategories,
          menuItems: menuItems,
          ratings: ratings);
    } catch (e) {
      print('Error fetching restaurant: $e');
      return Restaurant(
          id: restaurantId,
          name: 'Unknown',
          overallRating: 0.0,
          image: '',
          address: '',
        reviews: [],
          menuCategories: [],
          menuItems: [],
          ratings: []);
    }
  }

  Future<void> updateOverallRating(
      String restaurantId, double newRating) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('restaurants')
          .where(FieldPath.documentId, isEqualTo: restaurantId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        Map<String, dynamic> restaurantData =
            doc.data() as Map<String, dynamic>;

        List<double> ratings = restaurantData['ratings'] != null
            ? (restaurantData['ratings'] as List<dynamic>)
                .map((rating) => rating as double)
                .toList()
            : [];
        ratings.add(newRating);

        double overallRating = ratings.reduce((a, b) => a + b) / ratings.length;
        overallRating = double.parse(overallRating.toStringAsFixed(2));

        await _db.collection('restaurants').doc(restaurantId).update({
          'ratings': ratings,
          'overall_rating': overallRating,
        });

        print('Overall rating updated successfully.');
      } else {
        print('Restaurant not found.');
      }
    } catch (e) {
      print('Error updating overall rating: $e');
    }
  }
}
