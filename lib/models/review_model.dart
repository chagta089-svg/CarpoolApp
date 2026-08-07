class ReviewModel {
  String? reviewId;    
  double? rating;     
  double? ratingSafety;     
  double? ratingPrice;     
  double? ratingSatisfaction;     
  String? comment;     
  String? reviewDate;  

  ReviewModel({
    this.reviewId,
    this.rating,
    this.ratingSafety,
    this.ratingPrice,
    this.ratingSatisfaction,
    this.comment,
    this.reviewDate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ReviewModel(
      reviewId: documentId,
      rating: (json['rating'] ?? 0.0).toDouble(),
      ratingSafety: (json['ratingSafety'] ?? 0.0).toDouble(),
      ratingPrice: (json['ratingPrice'] ?? 0.0).toDouble(),
      ratingSatisfaction: (json['ratingSatisfaction'] ?? 0.0).toDouble(),
      comment: json['comment'],
      reviewDate: json['reviewDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'ratingSafety': ratingSafety,
      'ratingPrice': ratingPrice,
      'ratingSatisfaction': ratingSatisfaction,
      'comment': comment,
      'reviewDate': reviewDate,
    };
  }
}