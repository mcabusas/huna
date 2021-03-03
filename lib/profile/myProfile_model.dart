import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna/services/auth_services.dart';
import '../services/auth_services.dart';

class MyProfileModel {

  AuthServices _services = new AuthServices();

  Stream getReview(String uid, int flag) {
    var ret;
    if(flag == 0){
      ret = FirebaseFirestore.instance
      .collection('reviews')
      .where('s_uid', isEqualTo: uid)
      .snapshots();
    } else if(flag == 1){
      ret = FirebaseFirestore.instance
      .collection('reviews')
      .where('t_uid', isEqualTo: uid)
      .snapshots();
    }

    return ret;
    
  }

  Future<List<Map<String, dynamic>>> getTutorReviews(String uid) async {
    List<Map<String, dynamic>> retData = [];

      QuerySnapshot reviews = await FirebaseFirestore.instance
      .collection('reviews')
      .where('t_uid', isEqualTo: uid)
      .get();

      for(int i = 0; i < reviews.docs.length; i++){
        String reviewId = reviews.docs[i].id;

        DocumentReference reviewRef = FirebaseFirestore.instance
        .collection('reviews')
        .doc(reviewId);

        await reviewRef.get().then((data) => {
          retData.add({
            'content': data.data()['tutor_review'],
            'tutor_rating': data.data()['tutor_rating'],
          })
        });
      }

      return retData;
    

  }

  Future<List<Map<String, dynamic>>> getStudentReviews(String uid) async {
    List<Map<String, dynamic>> retData = [];

      QuerySnapshot reviews = await FirebaseFirestore.instance
      .collection('reviews')
      .where('s_uid', isEqualTo: uid)
      .get();

      for(int i = 0; i < reviews.docs.length; i++){
        String reviewId = reviews.docs[i].id;

        DocumentReference reviewRef = FirebaseFirestore.instance
        .collection('reviews')
        .doc(reviewId);

        await reviewRef.get().then((data) => {
          retData.add({
            'content': data.data()['student_review'],
            'student_rating': data.data()['student_rating'],
          })
        });
      }

      return retData;
    

  }

  
  
  Future<double> getRating(String uid, int flag) async {
    print(uid);
    double retRating = 0.0;
    String idFlag;

    if(flag == 0){
      //idFlag will use the uid to compare the student_id for the student rating

      idFlag = 's_uid';
    } else if(flag == 1){
      idFlag = 't_uid';
    }

    QuerySnapshot ratingsQuery = await FirebaseFirestore.instance
    .collection('reviews')
    .where(idFlag, isEqualTo: uid)
    .get();

    for(int i = 0; i < ratingsQuery.docs.length; i++){
      String ratingsid = ratingsQuery.docs[i].id;

      DocumentReference ratingsRef = FirebaseFirestore.instance
      .collection('reviews')
      .doc(ratingsid);

      await ratingsRef.get().then((value) => {
        //print(value.data()['tutor_rating']),

        retRating+=value.data()['tutor_rating']

      });


    }
    retRating/=ratingsQuery.docs.length;

    print(retRating.toString());

    return retRating;
  }


}