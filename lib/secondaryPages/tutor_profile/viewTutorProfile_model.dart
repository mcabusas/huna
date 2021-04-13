import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:huna/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../profile/myProfile_model.dart';


class ViewTutorProfileModel  extends MyProfileModel {

  AuthServices _authServices = new AuthServices();
  

  Future<Map<String, dynamic>> getTutorData(String uid, String tid) async {

    Map<String, dynamic> tutorData = {
      'majors': [],
      'topics': [],
      'languages': [],
      'rating': 0.0,
      'city': '',
      'country': ''
    };

    await FirebaseFirestore.instance
    .collection('tutors')
    .doc(tid)
    .get()
    .then((value) async {

      tutorData['majors'] = value.data()['majors'];
      tutorData['topics'] = value.data()['topics'];
      tutorData['languages'] = value.data()['languages'];

      QuerySnapshot ratingsQuery =  await FirebaseFirestore.instance
      .collection('reviews')
      .where('t_uid', isEqualTo: uid)
      .get();

      if(ratingsQuery.docs.length != 0){

        for(int i = 0; i < ratingsQuery.docs.length; i++){
          String ratingsid = ratingsQuery.docs[i].id;

          DocumentReference ratingsRef = FirebaseFirestore.instance
          .collection('reviews')
          .doc(ratingsid);

          await ratingsRef.get().then((value){
            tutorData['rating'] += value.data()['tutor_rating'];
          });
        }

        tutorData['rating']/=ratingsQuery.docs.length;

      }

      await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value){
        tutorData['city'] = value.data()['city'];
        tutorData['country'] = value.data()['country'];
      });


    });

    print(tutorData);
    


    return tutorData;
  }

  Future<bool> createReport(Map<String, dynamic> data) async {
    bool retVal = false;

    SharedPreferences sp = await SharedPreferences.getInstance();

    FirebaseFirestore.instance
    .collection('reports')
    .add(data)
    .then((value) => {
      retVal = true
    }).catchError((e) {
      print(e.toString());
    });


    return retVal;
  }

  Future<String> createChatRoom(QueryDocumentSnapshot tutorData) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print(sp.getString('uid'));

    String chatRoomId = getChatRoomId(sp.getString('uid'), tutorData['tid'].toString());

    FirebaseFirestore.instance
    .collection('chatrooms')
    .doc(chatRoomId)
    .set({
      
      'chatroomid': chatRoomId,
      'users': 
        {
          'studentid': sp.getString('uid'),
          'student_firstName': sp.getString('firstName'),
          'student_lastName': sp.getString('lastName'),
          'tutorid': tutorData['tid'],
          'tutor_firstName': tutorData['firstName'],
          'tutor_lastName': tutorData['lastName'],
          'tutor_userid': tutorData['uid'],
          'tutor_rate': tutorData['rate'],
        },
      

    }).catchError((e){
      print(e.toString());
    });

    return chatRoomId;
  }

  // Future<void> insertMessage() async {

  // }

  String getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }

  Future<bool> addToFavorites(QueryDocumentSnapshot data) async {

    bool retVal = false;

    User user = await _authServices.getCurrentUser();

    await FirebaseFirestore.instance
    .collection('favorites')
    .add({
      'tutor_firstName': data['firstName'],
      'tutor_lastName': data['lastName'],
      'tutor_uid': data['uid'],
      'tutor_tid': data['tid'],
      'student_uid': user.uid
    }).then((value) {
      retVal = true;
    });

    return retVal;
  }

}