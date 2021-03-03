import 'package:cloud_firestore/cloud_firestore.dart';

class RateReviewModel {


  Future<void> addReview(Map<String, dynamic> reviewContent, int flag) async{

    print(reviewContent);


    if(flag == 1){

      await FirebaseFirestore.instance
        .collection('reviews')
        .doc(reviewContent['bookingId'])
        .update({
          'bookingId': reviewContent['bookingId'],
          's_uid': reviewContent['s_uid'],
          't_uid': reviewContent['t_uid'],
          'student_rating': reviewContent['rating'],
          'student_review': reviewContent['review'],
        });


    }else if(flag == 0){
      await FirebaseFirestore.instance
        .collection('reviews')
        .doc(reviewContent['bookingId'])
        .update({
          'bookingId': reviewContent['bookingId'],
          's_uid': reviewContent['s_uid'],
          't_uid': reviewContent['t_uid'],
          'tutor_rating': reviewContent['rating'],
          'tutor_review': reviewContent['review'],
        });
    }

  }


}