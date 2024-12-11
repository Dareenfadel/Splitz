import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? id;
  final double rating;
  final String comment;
  final String userId;

  Review({
    this.id,
    required this.rating,
    required this.comment,
    required this.userId,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final firestore = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      rating: firestore['rating'],
      comment: firestore['comment'],
      userId: firestore['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'user_id': userId,
    };
  }
}
