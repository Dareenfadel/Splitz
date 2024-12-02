import 'package:splitz/data/models/review.dart';
import 'package:splitz/data/models/extra.dart';
import 'package:splitz/data/models/required_option.dart';

class MenuItem {
  final String id;
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
  final int count;
  MenuItem({
    required this.id,
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
    required this.count
  });

  factory MenuItem.fromFirestore(String id,Map<String, dynamic> firestore) {
    return MenuItem(
      id: id,
      name: firestore['name']??'',
      description: firestore['description']??'',
      image: firestore['image']??'',
      calories: firestore['calories']??0,
      preparationTime: firestore['preparation_time']??0,
      price: firestore['price']??0.0,
      overallRating: firestore['overall_rating']??0.0,
      reviews: (firestore['reviews'] as List? ?? [])
          .map((e) => Review.fromFirestore(e))
          .toList(),
      extras: (firestore['extras'] as List? ?? [])
          .map((e) => Extra.fromFirestore(e))
          .toList(),
      requiredOptions: (firestore['required_options'] as List? ?? [])
          .map((e) => RequiredOption.fromFirestore(e))
          .toList(),
      count: firestore['count']??0,

    );
  }

  MenuItem copyWith({
    String? id,
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
      id: id ?? this.id,
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
      count: count
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
