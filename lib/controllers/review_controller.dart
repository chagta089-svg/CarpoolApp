import 'package:carpool_app/services/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/review_model.dart';

class ReviewController {
  final DatabaseReference _dbRef = dbRef;

  // เพิ่มรีวิว
  Future<bool> addReview(String driverId, String tripId, String passengerId, ReviewModel review) async {
    try {
    await _dbRef
        .child('Member/$driverId/ShareTrip/$tripId/Review/$passengerId')
        .set(review.toJson());
    return true;
    } catch (e) {
      print("Error adding review: $e");
      return false;
    }
  }

  Future<List<ReviewModel>> getReviewsByDriverId(String memberId) async {
  try {
    // ดึงจาก Member/$memberId/ShareTrip ก่อน
    DataSnapshot snapshot = await _dbRef.child('Member/$memberId/ShareTrip').get();
    if (!snapshot.exists) return [];
    
    List<ReviewModel> allReviews = [];
    Map<dynamic, dynamic> tripsMap = Map<dynamic, dynamic>.from(snapshot.value as Map);
    
    tripsMap.forEach((tripId, tripData) {
      if (tripData is Map && tripData.containsKey('Review')) {
        Map<dynamic, dynamic> reviewsMap = Map<dynamic, dynamic>.from(tripData['Review'] as Map);
        reviewsMap.forEach((passengerId, reviewData) {
          allReviews.add(
            ReviewModel.fromJson(
              Map<String, dynamic>.from(reviewData),
              passengerId.toString(),
            )
          );
        });
      }
    });
    
    return allReviews;
  } catch (e) {
    print("Error fetching reviews: $e");
    return [];
  }
}
}