class Review {
  int? reviewId;
  int propertyId;
  int reviewerId;
  int rating;
  String comment;

  Review({
    this.reviewId,
    required this.propertyId,
    required this.reviewerId,
    required this.rating,
    required this.comment,
  });
  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'propertyId': propertyId,
      'reviewerId': reviewerId,
      'rating': rating,
      'comment': comment,
    };
  }
}