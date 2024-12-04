import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitz/data/models/choice.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/required_option.dart';
import 'package:splitz/data/models/extra.dart';
import 'package:splitz/data/models/review.dart';

class MenuItemService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new menu item along with required options and extras (empty reviews)
  Future<void> addMenuItem(
      String restaurantId, MenuItemModel item, String? CategoryId) async {
    try {
      // Add the new menu item to the Firestore collection
      DocumentReference itemRef = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .add({
        'name': item.name,
        'description': item.description,
        'image': item.image,
        'calories': item.calories,
        'discount': item.discount,
        'preparation_time': item.preparationTime,
        'price': item.price,
        'overall_rating': item.overallRating,
        'count':0,
      });

      print('Menu item added with ID: ${itemRef.id}');

      // Add required options (empty choices for now)
      for (var option in item.requiredOptions) {
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
            // 'id': choice.id,
            'name': choice.name,
            'price': choice.price,
          });
        }
      }

      // Add extras
      for (var extra in item.extras) {
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

      print(
          'Required options and extras added, reviews collection initialized');
    } catch (e) {
      print('Error adding menu item with options and extras: $e');
    }
  }

  // Update an existing menu item, its required options, extras
  Future<void> updateMenuItem(String restaurantId, String menuItemId,
      MenuItemModel item, String? CategoryId) async {
    try {
      // Update the menu item document in Firestore
      await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .update({
        'name': item.name,
        'description': item.description,
        'image': item.image,
        'calories': item.calories,
        'preparation_time': item.preparationTime,
        'price': item.price,
        'overall_rating': item.overallRating,
      });

      print('Menu item updated with ID: $menuItemId');

      // Update the required options (adding/removing options based on the new list)
      for (var option in item.requiredOptions) {
        DocumentReference optionRef;
        try {
          optionRef = await _db
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menu_items')
              .doc(menuItemId)
              .collection('required_options')
              .doc(option.id); // Reference the option by ID

          await optionRef.update({
            'name': option.name,
          });
        } catch (e) {
          optionRef = await _db
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menu_items')
              .doc(menuItemId)
              .collection('required_options')
              .add({
            'name': option.name,
          });
        }

        // Update the choices for the option
        for (var choice in option.choices) {
          try {
            await _db
                .collection('restaurants')
                .doc(restaurantId)
                .collection('menu_items')
                .doc(menuItemId)
                .collection('required_options')
                .doc(option.id)
                .collection('choices')
                .doc(choice.id)
                .update({
              'name': choice.name,
              'price': choice.price,
            });
          } catch (e) {
            await _db
                .collection('restaurants')
                .doc(restaurantId)
                .collection('menu_items')
                .doc(menuItemId)
                .collection('required_options')
                .doc(optionRef.id)
                .collection('choices')
                .add({
              'name': choice.name,
              'price': choice.price,
            });
          }
        }
      }

      // Update the extras
      for (var extra in item.extras) {
        try {
          DocumentReference extraRef = await _db
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menu_items')
              .doc(menuItemId)
              .collection('extras')
              .doc(extra.id);
          // Reference the extra by ID

          await extraRef.update({
            'name': extra.name,
            'price': extra.price,
          });
        } catch (e) {
          await _db
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menu_items')
              .doc(menuItemId)
              .collection('extras')
              .add({
            'name': extra.name,
            'price': extra.price,
          });
        }
      }

      print('Required options, extras updated successfully');
    } catch (e) {
      print('Error updating menu item with options, extras, and reviews: $e');
    }
  }

  // Fetch a menu item by its ID, including required options, choices, extras, and reviews
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

      MenuItemModel menuItem = MenuItemModel.fromFirestore(menuItemSnapshot);

      // Fetch the required options for the menu item
      QuerySnapshot requiredOptionsSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .collection('required_options')
          .get();

      // Map the required options and fetch the choices for each option
      List<RequiredOption> requiredOptions = await Future.wait(
        requiredOptionsSnapshot.docs.map((doc) async {
          // Convert each option document into a RequiredOption model
          RequiredOption requiredOption = RequiredOption.fromFirestore(doc);

          // Fetch choices for the current required option
          QuerySnapshot choicesSnapshot = await _db
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menu_items')
              .doc(menuItemId)
              .collection('required_options')
              .doc(doc.id)
              .collection('choices')
              .get();

          // Map the choices into a list
          List<Choice> choices = choicesSnapshot.docs.map((choiceDoc) {
            return Choice.fromFirestore(choiceDoc);
          }).toList();

          // Add choices to the required option
          return requiredOption.copyWith(choices: choices);
        }).toList(),
      );

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
        return Extra.fromFirestore(doc);
      }).toList();

      // Fetch the reviews for the menu item (if any)
      QuerySnapshot reviewsSnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .collection('reviews')
          .get();
      List<Review> reviews;
      if (reviewsSnapshot.docs.isNotEmpty) {
        reviews = reviewsSnapshot.docs.map((doc) {
          return Review.fromFirestore(doc);
        }).toList();
      } else {
        reviews = [];
      }

      // Return the menu item with all its attributes (including required options, choices, extras, and reviews)
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

//fetch all items within certain category
  Future<List<MenuItemModel>> fetchItemsByCategory(
      String restaurantId, String categoryId) async {
    try {
      // Fetch the specific category
      final categoryDoc = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_categories')
          .doc(categoryId)
          .get();

      if (!categoryDoc.exists) {
        throw Exception("Menu category not found");
      }

      final category = MenuCategory.fromFirestore(categoryDoc);

      // Fetch all menu items based on itemIds in the category
      final itemIds = category.itemIds;
      if (itemIds.isEmpty) {
        return []; // Return empty list if no items in the category
      }

      // Fetch items in parallel
      final itemFutures = itemIds.map((itemId) {
        return _db
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menu_items')
            .doc(itemId)
            .get();
      });

      final itemDocs = await Future.wait(itemFutures);

      // Convert Firestore documents to MenuItemModel
      return itemDocs
          .where((doc) => doc.exists) // Ensure the item exists
          .map((doc) => MenuItemModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching items by category: $e");
      return [];
    }
  }

  Future<List<MenuItemModel>> fetchAllItems(String restaurantId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .get();

      return snapshot.docs.map((doc) {
        return MenuItemModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Error fetching menu items: $e');
      return [];
    }
  }

  Future<void> deleteRemovedChoices(Map<String, List<String>> removedChoices,
      String restaurantId, String menuItemId) async {
    // Loop through the map
    for (var requiredOptionId in removedChoices.keys) {
      List<String> choiceIds = removedChoices[requiredOptionId]!;

      for (var choiceId in choiceIds) {
        // Assuming you're deleting documents from a collection named 'choices'
        try {
          await _db
              .collection('restaurants')
              .doc(restaurantId)
              .collection('menu_items')
              .doc(menuItemId)
              .collection('required_options')
              .doc(requiredOptionId)
              .collection('choices')
              .doc(choiceId)
              .delete();
          print(
              'Deleted choice with ID: $choiceId from required option $requiredOptionId');
        } catch (e) {
          print('Error deleting choice with ID: $choiceId - $e');
        }
      }
    }
  }

  Future<void> deleteRemovedOptions(List<String> removedOptions,
      String restaurantId, String menuItemId) async {
    for (var optionId in removedOptions) {
      try {
        // Assuming you're deleting documents from a collection named 'requiredOptions'
        await _db
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menu_items')
            .doc(menuItemId)
            .collection('required_options')
            .doc(optionId)
            .delete();
        print('Deleted required option with ID: $optionId');
      } catch (e) {
        print('Error deleting required option with ID: $optionId - $e');
      }
    }
  }

  Future<void> deleteRemovedExtras(List<String> removedExtras,
      String restaurantId, String menuItemId) async {
    for (var extraId in removedExtras) {
      try {
        // Assuming you're deleting documents from a collection named 'requiredOptions'

        await _db
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menu_items')
            .doc(menuItemId)
            .collection('extras')
            .doc(extraId)
            .delete();
        print('Deleted required option with ID: $extraId');
      } catch (e) {
        print('Error deleting required option with ID: $extraId - $e');
      }
    }
  }

  Future<void> addNewItemToCategory(
      String restaurantId, String CategoryId, String itemId) async {
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu_categories')
        .doc(CategoryId)
        .update({
      'item_ids': FieldValue.arrayUnion([itemId])
    });
  }

  Future<void> RemoveMenuItemFromCategory(
      String restaurantId, String MenuItemId, String CategoryId) async {
    try {
      // Fetch the MenuCategory document
      DocumentSnapshot categorySnapshot = await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_categories')
          .doc(CategoryId)
          .get();

      if (categorySnapshot.exists) {
        final category = MenuCategory.fromFirestore(categorySnapshot);

        // Fetch all menu items based on itemIds in the category
        var items = category.itemIds;

        items.remove(MenuItemId);

        await _db
            .collection('restaurants')
            .doc(restaurantId)
            .collection('menu_categories')
            .doc(CategoryId)
            .update({'item_ids': items});
      } else {
        print("Category not found");
      }
    } catch (e) {
      print("Error removing menu item: $e");
    }
  }

  Future<void> deleteMenuItem(String restaurantId, String menuItemId) async {
    try {
      await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_items')
          .doc(menuItemId)
          .delete();
    } catch (e) {
      print('Error deleting item ${e}');
    }
  }

  Future<void> deleteMenuaCategory(
      String restaurantId, String menuCategoryId) async {
    try {
      await _db
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu_categories')
          .doc(menuCategoryId)
          .delete();
    } catch (e) {
      print('Error deleting category ${e}');
    }
  }
}
