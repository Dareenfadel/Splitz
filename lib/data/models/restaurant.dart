import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/models/menu_item.dart';
import 'package:splitz/data/models/review.dart';

class Restaurant {
  String? id;
  final String name;
  final double overallRating;
  final String image;
  final String? address;
  final List<Review> reviews;
  final List<MenuCategory> menuCategories;
  final List<MenuItemModel> menuItems; // Directly inside the restaurant
  final List<double> ratings;

  Restaurant({
    this.id,
    required this.name,
    required this.overallRating,
    required this.image,
    this.address,
    required this.reviews,
    required this.menuCategories,
    required this.menuItems,
    required this.ratings,
  });
// Fetching Restaurant Data only not enough need to fetch menu categories and menu items to create Restaurant object(use fetch in restaurant_service.dart)
  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    final firestore = doc.data() as Map<String, dynamic>;
    return Restaurant(
      id: doc.id,
      name: firestore['name'],
      overallRating: firestore['overall_rating'],
      image: firestore['image'],
      address: firestore['address'],
      reviews: (firestore['reviews'] as List)
          .map((e) => Review.fromFirestore(e))
          .toList(),
      menuCategories: (firestore['menu_categories'] as List)
          .map((e) => MenuCategory.fromFirestore(e))
          .toList(),
      menuItems: (firestore['menu_items'] as List)
          .map((e) => MenuItemModel.fromFirestore(e))
          .toList(),
      ratings: (firestore['ratings'] as List<dynamic>? ?? [])
          .map((e) => e as double)
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'overall_rating': overallRating,
      'image': image,
      'address': address,
      'reviews': reviews.map((e) => e.toMap()).toList(),
      'menu_categories': menuCategories.map((e) => e.toMap()).toList(),
      'menu_items': menuItems.map((e) => e.toMap()).toList(),
      'ratings': ratings,
    };
  }
}
