import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitz/data/models/review.dart';
import 'package:splitz/data/models/extra.dart';
import 'package:splitz/data/models/required_option.dart';

class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final int calories;
  final int preparationTime;
  final double price;
  final double? discount;
  final double overallRating;
  List<double> ratings;
  final List<Review> reviews;
  final List<Extra> extras;
  final List<RequiredOption> requiredOptions;
  final int? count;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.calories,
    required this.preparationTime,
    required this.price,
    this.discount,
    required this.overallRating,
    required this.reviews,
    required this.extras,
    required this.requiredOptions,
    this.count,
    this.ratings = const [],
  });
  
  double get averageRating {
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((value, element) => value + element) / ratings.length;
  }

  factory MenuItemModel.fromFirestore(DocumentSnapshot doc) {
    final firestore = doc.data() as Map<String, dynamic>;
    return MenuItemModel(
      id: doc.id,
      name: firestore['name'],
      description: firestore['description'],
      image: firestore['image'],
      discount: firestore['discount'],
      calories: firestore['calories'],
      preparationTime: firestore['preparation_time'],
      price: (firestore['price'] ?? 0.0).toDouble(),
      overallRating: (firestore['overall_rating'] ?? 0.0).toDouble(),
      reviews: (firestore['reviews'] as List? ?? [])
          .map((e) => Review.fromFirestore(e))
          .toList(),
      extras: (firestore['extras'] as List? ?? [])
          .map((e) => Extra.fromFirestore(e))
          .toList(),
      requiredOptions: (firestore['required_options'] as List? ?? [])
          .map((e) => RequiredOption.fromFirestore(e))
          .toList(),
      count: firestore['count'] ?? 0,
      ratings: (firestore['ratings'] as List? ?? [])
          .map((e) => e is double ? e : 0.0)
          .toList(),
    );
  }

  MenuItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    int? calories,
    int? preparationTime,
    double? price,
    double? discount,
    double? overallRating,
    List<RequiredOption>? requiredOptions,
    List<Extra>? extras,
    List<Review>? reviews,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      calories: calories ?? this.calories,
      preparationTime: preparationTime ?? this.preparationTime,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      overallRating: overallRating ?? this.overallRating,
      requiredOptions: requiredOptions ?? this.requiredOptions,
      extras: extras ?? this.extras,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'calories': calories,
      'preparation_time': preparationTime,
      'price': price,
      'discount': discount,
      'overall_rating': overallRating,
      'reviews': reviews.map((e) => e.toMap()).toList(),
      'extras': extras.map((e) => e.toMap()).toList(),
      'required_options': requiredOptions.map((e) => e.toMap()).toList(),
      'ratings': ratings,
    };
  }
}
