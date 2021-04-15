import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../services/auth_services.dart';

class MyProfileModel {

  SharedPreferences sp;


  Future<String> getPicture(String uid) async {
    String imageUrl = '';
     await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .get().then((value) => {
      imageUrl = value.data()['picture']
    });

    print(imageUrl);

  return imageUrl;

  }

  Future uploadPicture(String uid, File file) async {
    print(uid);


    try{
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images/')
      .child(uid+'.jpg');

      firebase_storage.UploadTask uploadTask = ref.putFile(file);
      var url = (await uploadTask.then((value) => {
        value.ref.getDownloadURL().then((value) async => {
          await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
            'picture': value.toString()+".jpg"
          })
        })
      }));
      
    }catch (e){
      print(e.toString());
      print('error in uppload image');
    }
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

  Future<Map<String, List<String>>> getTags(String tid) async {
    Map<String, dynamic> retData = {};
    DocumentSnapshot data = await FirebaseFirestore.instance
    .collection('tutors')
    .doc(tid)
    .get();
    
    retData = {
      'languages': data.data()['languages'],
      'majors': data.data()['majors'],
      'topics': data.data()['topics']
    };

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

  Stream getSettingsData(String uid) {
    return FirebaseFirestore.instance
    .collection('users')
    .where('uid', isEqualTo: uid)
    .snapshots().handleError((e)=>{
      print(e.toString())
    });
  }

  Future<bool> editStudentEmergencyContact(String uid, Map<String, dynamic> data) async {
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

    }).catchError((e) => {
      print(e.toString())
    });

    return retVal;
  }

  Future<bool> updateMajorTags(String tid, List<String> majors) async {
    print(tid);
    print(majors);

     bool retVal = false;
    await FirebaseFirestore.instance
    .collection('tutors')
    .doc(tid)
    .update({
      'majors': majors
    }).then((value) => {
      retVal = true
    }).catchError((e) => {
      print(e.toString())
    });

    return retVal;

  }

  Future<bool> updateLanguageTags(String tid, List<String> languages) async {

    bool retVal = false;
    await FirebaseFirestore.instance
    .collection('tutors')
    .doc(tid)
    .update({
      'languages': languages
    }).then((value) => {
      retVal = true
    }).catchError((e) => {
      print(e.toString())
    });

    return retVal;

  }

  Future<bool> updateTopicsTags(String tid, List<String> topics) async {

    bool retVal = false;
    await FirebaseFirestore.instance
    .collection('tutors')
    .doc(tid)
    .update({
      'topics': topics
    }).then((value) => {
      retVal = true
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
      .where('s_uid', isEqualTo: '5ki91DZXHsUTzgPhHI8IPPBzo2C2')
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

    return retRating;
  }


}