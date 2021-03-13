import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:huna/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ViewTutorProfileModel {

  AuthServices _authServices = new AuthServices();
  

  Future<Map<String, dynamic>> getTutorData(String tid) async {

    Map<String, dynamic> tutorData = {
      'majors': [],
      'topics': [],
      'rating': 0.0,
    };

    await FirebaseFirestore.instance
    .collection('tutors')
    .doc(tid)
    .get()
    .then((value) async {

      tutorData['majors'] = value.data()['majors'];
      tutorData['topics'] = value.data()['topics'];

      QuerySnapshot ratingsQuery =  await FirebaseFirestore.instance
      .collection('reviews')
      .where('t_uid', isEqualTo: tid)
      .get();

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


    });

    print(tutorData);
    


    return tutorData;
  }

  Future<String> createChatRoom(Map<String, dynamic> tutorData) async {
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

  Future<bool> addToFavorites(Map<String, dynamic> data) async {

    bool retVal = false;

    User user = await _authServices.getCurrentUser();
    print(user.uid);
    data['user_id'] = user.uid;
    print(data);

    await FirebaseFirestore.instance
    .collection('favorites')
    .add(data).then((value) {
      retVal = true;
    });

    return retVal;
  }

}