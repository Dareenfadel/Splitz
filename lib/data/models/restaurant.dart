import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/review.dart';

class Restaurant {
  final String name;
  final double overallRating;
  final String image;
  final List<Review> reviews;
  final List<MenuCategory> menuCategories;
  final List<MenuItem> menuItems; // Directly inside the restaurant

  Restaurant({
    required this.name,
    required this.overallRating,
    required this.image,
    required this.reviews,
    required this.menuCategories,
    required this.menuItems,
  });

  factory Restaurant.fromFirestore(Map<String, dynamic> firestore) {
    return Restaurant(
      name: firestore['name'],
      overallRating: firestore['overall_rating'],
      image: firestore['image'],
      reviews: (firestore['reviews'] as List)
          .map((e) => Review.fromFirestore(e))
          .toList(),
      menuCategories: (firestore['menu_categories'] as List)
          .map((e) => MenuCategory.fromFirestore(e))
          .toList(),
      menuItems: (firestore['menu_items'] as List)
          .map((e) => MenuItem.fromFirestore(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'overall_rating': overallRating,
      'image': image,
      'reviews': reviews.map((e) => e.toMap()).toList(),
      'menu_categories': menuCategories.map((e) => e.toMap()).toList(),
      'menu_items': menuItems.map((e) => e.toMap()).toList(),
    };
  }
}
