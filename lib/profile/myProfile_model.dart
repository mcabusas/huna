import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_storage';

class MyProfileModel {

  SharedPreferences sp;

  Future<bool> uploadPicture(String uid, String fileName) async {
    bool retVal = false;

    //FirebaseStorage _storage = FirebaseStorage.instance;



    return retVal;
  }

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

  Future<bool> editRate(String tid, String newRate) async {

    bool retVal = false;

    await FirebaseFirestore.instance
    .collection('tutors')
    .doc(tid)
    .update({

      'rate': newRate

    }).then((value) => {
      retVal = true
    }).catchError((e){
      print(e.toString());
    });

    return retVal;

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

  Stream getTutorRateAndTags(String uid){
    return FirebaseFirestore.instance
    .collection('tutors')
    .where('uid', isEqualTo: uid)
    .snapshots()
    .handleError((e) => {
      print(e.toString())
    });

  }

  Future<bool> editStudentEmergencyContant(String uid, Map<String, dynamic> data) async {
    bool retVal = false;  
    print(data);

    await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .update({

      'emergencyFirstName': data['emergencyFirstName'],
      'emergencyLastName': data['emergencyLastName'],
      'emergencyContactNumber': data['emergencyContactNumber'],
      'emergencyRelation': data['emergencyRelation']

    }).then((value) async => {
      sp = await SharedPreferences.getInstance(),
      retVal = true,
      sp.setString('emergencyFirstName', data['emergencyFirstName']),
      sp.setString('emergencyLastName', data['emergencyLastName']),
      sp.setString('emergencyContactNumber', data['emergencyContactNumber']),
      sp.setString('emergencyRelation', data['emergencyRelation ']),

    }).catchError((e) => {
      print(e.toString())
    });

    return retVal;
  }

  Future<bool> editStudentPersonalDetails(String uid, Map<String, dynamic> data) async {
    print(data);
    bool retVal = false;
    await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .update({
      'homeAddress': data['homeAddress'],
      'city': data['city'],
      'country': data['country'],
      'zipCode': data['zipCode'],
      'contactNumber': data['contactNumber']

    }).then((value) => {
      retVal = true
    }).catchError((e) => {
      print(e.toString())
    });

    return retVal;

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