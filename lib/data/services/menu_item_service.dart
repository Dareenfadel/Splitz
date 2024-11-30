import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitz/data/models/choice.dart';

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
  Future<MenuItemModel?> fetchMenuItemWithDetails(
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
      print("hey1");
      // Convert the menu item document to a MenuItem object
      MenuItemModel menuItem = MenuItemModel.fromFirestore(menuItemSnapshot);
      print("hey2");
      // Fetch the required options for the menu item
      QuerySnapshot requiredOptionsSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .collection('required_options')
          .get();
      print("hey3");
      // Map the required options
      List<RequiredOption> requiredOptions =
          requiredOptionsSnapshot.docs.map((doc) {
        return RequiredOption.fromFirestore(doc);
      }).toList();
      print("hey4");
      // Fetch the extras for the menu item
      QuerySnapshot extrasSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .collection('extras')
          .get();
      print("hey5");
      // Map the extras
      List<Extra> extras = extrasSnapshot.docs.map((doc) {
        return Extra.fromFirestore(doc);
      }).toList();
      print("hey6");
      // Fetch the reviews for the menu item (if any)
      QuerySnapshot reviewsSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .collection('reviews')
          .get();
      print("hey7");
      // Map the reviews
      List<Review> reviews = reviewsSnapshot.docs.map((doc) {
        return Review.fromFirestore(doc);
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

  void addDummyData() async {
    MenuItemService menuItemService = MenuItemService();

    // Dummy restaurant ID
    String restaurantId = 'ZVCMxkUQjp6zcYv6NlYH';

    // Dummy menu item data
    String name = 'Spaghetti Bolognese';
    String description = 'Delicious spaghetti with rich bolognese sauce.';
    String image =
        'https://media.istockphoto.com/id/1309352410/photo/cheeseburger-with-tomato-and-lettuce-on-wooden-board.jpg?s=1024x1024&w=is&k=20&c=XXp34bPwWkHPUXbZQRJpR1w2YUSpYZUB_yNdeDlVXlQ='; // Use any image URL
    int calories = 600;
    int preparationTime = 30;
    double price = 12.99;
    double overallRating = 4.5;

    // Dummy required options
    List<RequiredOption> requiredOptions = [
      RequiredOption(
        name: 'Choose Pasta Type',
        choices: [
          Choice(id: '1', name: 'Spaghetti', price: 0.0),
          Choice(id: '2', name: 'Penne', price: 0.0),
        ],
        id: '1',
      ),
      RequiredOption(
        name: 'Choose Sauce',
        choices: [
          Choice(id: '3', name: 'Bolognese', price: 0.0),
          Choice(id: '4', name: 'Arrabbiata', price: 0.0),
        ],
        id: '2',
      ),
    ];

    // Dummy extras
    List<Extra> extras = [
      Extra(name: 'Extra Cheese', price: 1.5, id: '1'),
      Extra(name: 'Garlic Bread', price: 2.5, id: '2'),
    ];

    // Add the dummy menu item to the database
    await menuItemService.addMenuItem(
      restaurantId,
      name,
      description,
      image,
      calories,
      preparationTime,
      price,
      overallRating,
      requiredOptions,
      extras,
    );

    print('Dummy data added successfully!');
  }

  Future<void> createDummyMenuItem() async {
    try {
      String restaurantId = 'ZVCMxkUQjp6zcYv6NlYH';
      // Reference to the menu_items collection
      CollectionReference menuItemsRef = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items');

      // Add a new menu item (Firestore will generate the ID)
      DocumentReference menuItemDoc = await menuItemsRef.add({
        'name': 'Dummy Menu Item',
        'description': 'This is a dummy menu item.',
        'price': 9.99,
      });

      // Reference to the required_options subcollection
      CollectionReference requiredOptionsRef =
          menuItemDoc.collection('required_options');

      // Add required options
      DocumentReference requiredOptionDoc = await requiredOptionsRef.add({
        'name': 'Choose Your Size',
        'isRequired': true,
      });

      // Reference to the choices subcollection
      CollectionReference choicesRef = requiredOptionDoc.collection('choices');

      // Add choices for the required option
      await choicesRef.add({'name': 'Small', 'price': 0.0});
      await choicesRef.add({'name': 'Medium', 'price': 1.0});
      await choicesRef.add({'name': 'Large', 'price': 2.0});

      print('Dummy menu item created successfully!');
    } catch (e) {
      print('Error creating dummy menu item: $e');
    }
  }
}
