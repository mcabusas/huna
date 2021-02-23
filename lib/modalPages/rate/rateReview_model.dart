import 'package:cloud_firestore/cloud_firestore.dart';

class RateReviewModel {


  Future<void> addReview(Map<String, dynamic> reviewContent) async{

    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(reviewContent['bookingId'])
    .update({
      'reviewData': reviewContent,
    });

  }


}