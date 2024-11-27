import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/required_option.dart';
import 'package:splitz/data/models/extra.dart';
import 'package:splitz/data/models/review.dart';

class MenuItemService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new menu item along with required options and extras (empty reviews)
  Future<void> addMenuItem(
    String restaurantId,
    String name,
    String description,
    String image,
    int calories,
    int preparationTime,
    double price,
    double overallRating,
    List<RequiredOption> requiredOptions,
    List<Extra> extras,
  ) async {
    try {
      // Add the new menu item to the Firestore collection
      DocumentReference itemRef = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .add({
        'name': name,
        'description': description,
        'image': image,
        'calories': calories,
        'preparation_time': preparationTime,
        'price': price,
        'overall_rating': overallRating,
      });

      print('Menu item added with ID: ${itemRef.id}');

      // Add required options (empty choices for now)
      for (var option in requiredOptions) {
        DocumentReference optionRef = await _db
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menu_items')
            .doc(itemRef.id)
            .collection('required_options')
            .add({
          'name': option.name,
        });

        for (var choice in option.choices) {
          await _db
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menu_items')
              .doc(itemRef.id)
              .collection('required_options')
              .doc(optionRef.id)
              .collection('choices')
              .add({
            'id': choice.id,
            'name': choice.name,
            'price': choice.price,
          });
        }
      }

      // Add extras
      for (var extra in extras) {
        await _db
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menu_items')
            .doc(itemRef.id)
            .collection('extras')
            .add({
          'name': extra.name,
          'price': extra.price,
        });
      }

      // Create an empty reviews collection (No reviews initially)
      await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(itemRef.id)
          .collection('reviews')
          .add({}); // Empty review for now

      print(
          'Required options and extras added, reviews collection initialized');
    } catch (e) {
      print('Error adding menu item with options and extras: $e');
    }
  }

  // Fetch a menu item by its ID, including required options, extras, and reviews
  Future<MenuItem?> fetchMenuItemWithDetails(
      String restaurantId, String menuItemId) async {
    try {
      // Fetch the menu item document
      DocumentSnapshot menuItemSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .get();

      if (!menuItemSnapshot.exists) {
        print('Menu item not found');
        return null;
      }

      // Convert the menu item document to a MenuItem object
      MenuItem menuItem = MenuItem.fromFirestore(
        menuItemSnapshot.id,
          menuItemSnapshot.data() as Map<String, dynamic>);

      // Fetch the required options for the menu item
      QuerySnapshot requiredOptionsSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .collection('required_options')
          .get();

      // Map the required options
      List<RequiredOption> requiredOptions =
          requiredOptionsSnapshot.docs.map((doc) {
        return RequiredOption.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      // Fetch the extras for the menu item
      QuerySnapshot extrasSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .collection('extras')
          .get();

      // Map the extras
      List<Extra> extras = extrasSnapshot.docs.map((doc) {
        return Extra.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      // Fetch the reviews for the menu item (if any)
      QuerySnapshot reviewsSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .collection('reviews')
          .get();

      // Map the reviews
      List<Review> reviews = reviewsSnapshot.docs.map((doc) {
        return Review.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      // Return the menu item with all its attributes
      menuItem = menuItem.copyWith(
        requiredOptions: requiredOptions,
        extras: extras,
        reviews: reviews,
      );

      return menuItem;
    } catch (e) {
      print('Error fetching menu item with details: $e');
      return null;
    }
  }
}
