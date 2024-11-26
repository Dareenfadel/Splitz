class Review {
  final double rating;
  final String comment;
  final String userId;

  Review({
    required this.rating,
    required this.comment,
    required this.userId,
  });

  factory Review.fromFirestore(Map<String, dynamic> firestore) {
    return Review(
      rating: firestore['rating'],
      comment: firestore['comment'],
      userId: firestore['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'comment': comment,
      'user_id': userId,
    };
  }
}
