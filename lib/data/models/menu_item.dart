import 'package:splitz/data/models/review.dart';
import 'package:splitz/data/models/extra.dart';
import 'package:splitz/data/models/required_option.dart';

class MenuItem {
  final String name;
  final String description;
  final String image;
  final int calories;
  final int preparationTime;
  final double price;
  final double overallRating;
  final List<Review> reviews;
  final List<Extra> extras;
  final List<RequiredOption> requiredOptions;

  MenuItem({
    required this.name,
    required this.description,
    required this.image,
    required this.calories,
    required this.preparationTime,
    required this.price,
    required this.overallRating,
    required this.reviews,
    required this.extras,
    required this.requiredOptions,
  });

  factory MenuItem.fromFirestore(Map<String, dynamic> firestore) {
    return MenuItem(
      name: firestore['name'],
      description: firestore['description'],
      image: firestore['image'],
      calories: firestore['calories'],
      preparationTime: firestore['preparation_time'],
      price: firestore['price'],
      overallRating: firestore['overall_rating'],
      reviews: (firestore['reviews'] as List)
          .map((e) => Review.fromFirestore(e))
          .toList(),
      extras: (firestore['extras'] as List)
          .map((e) => Extra.fromFirestore(e))
          .toList(),
      requiredOptions: (firestore['required_options'] as List)
          .map((e) => RequiredOption.fromFirestore(e))
          .toList(),
    );
  }

  MenuItem copyWith({
    String? name,
    String? description,
    String? image,
    int? calories,
    int? preparationTime,
    double? price,
    double? overallRating,
    List<RequiredOption>? requiredOptions,
    List<Extra>? extras,
    List<Review>? reviews,
  }) {
    return MenuItem(
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      calories: calories ?? this.calories,
      preparationTime: preparationTime ?? this.preparationTime,
      price: price ?? this.price,
      overallRating: overallRating ?? this.overallRating,
      requiredOptions: requiredOptions ?? this.requiredOptions,
      extras: extras ?? this.extras,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'calories': calories,
      'preparation_time': preparationTime,
      'price': price,
      'overall_rating': overallRating,
      'reviews': reviews.map((e) => e.toMap()).toList(),
      'extras': extras.map((e) => e.toMap()).toList(),
      'required_options': requiredOptions.map((e) => e.toMap()).toList(),
    };
  }
}
