import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:huna/services/auth_services.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../profile/myProfile_model.dart';
import '../../favorites/favorites_model.dart';

class ViewTutorProfileModel extends MyProfileModel {
  AuthServices _authServices = new AuthServices();

  Future<double> getTutorData(String uid) async {
    double rating = 0.0;
    QuerySnapshot ratingsQuery = await FirebaseFirestore.instance
          .collection('reviews')
          .where('t_uid', isEqualTo: uid)
          .get();

      if (ratingsQuery.docs.length != 0) {
        for (int i = 0; i < ratingsQuery.docs.length; i++) {
          String ratingsid = ratingsQuery.docs[i].id;

          DocumentReference ratingsRef =
              FirebaseFirestore.instance.collection('reviews').doc(ratingsid);

          await ratingsRef.get().then((value) {
            rating += value.data()['tutor_rating'];
          });
        }

        rating /= ratingsQuery.docs.length;
      }

    

    return rating;
  }

  Future<bool> createReport(Map<String, dynamic> data) async {
    bool retVal = false;

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    String rid = randomAlphaNumeric(15);
    data['report_id'] = rid;
    data['date_created'] = formattedDate;

    await FirebaseFirestore.instance
    .collection('reports')
    .doc(rid)
    .set(data)
    .then((value) => {
      retVal = true
    }).catchError((e) => {
      print(e.toString())
    });

    return retVal;
  }

  Future<String> createChatRoom(var tutorData) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print(sp.getString('uid'));

    String chatRoomId =
        getChatRoomId(sp.getString('uid'), tutorData['tid'].toString());

    FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).set({
      'chatroomid': chatRoomId,
      'users': {
        'studentid': sp.getString('uid'),
        'student_firstName': sp.getString('firstName'),
        'student_lastName': sp.getString('lastName'),
        'tutorid': tutorData['tid'],
        'tutor_firstName': tutorData['firstName'],
        'tutor_lastName': tutorData['lastName'],
        'tutor_userid': tutorData['uid'],
        'tutor_rate': tutorData['rate'],
      },
    }).catchError((e) {
      print(e.toString());
    });

    return chatRoomId;
  }

  // Future<void> insertMessage() async {

  // }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Future<bool> addToFavorites(var data) async {
    bool retVal = false;

    User user = await _authServices.getCurrentUser();

    QuerySnapshot favRef = await FirebaseFirestore.instance
        .collection('favorites')
        .where('tutor_tid', isEqualTo: data['tid'])
        .where('student_uid', isEqualTo: user.uid)
        .get();

    if (favRef.docs.length == 0) {
      await FirebaseFirestore.instance.collection('favorites').add({
        'tutor_firstName': data['firstName'],
        'tutor_lastName': data['lastName'],
        'tutor_uid': data['uid'],
        'tutor_tid': data['tid'],
        'student_uid': user.uid
      }).then((value) {
        retVal = true;
      });
    }

    return retVal;
  }

  Future<bool> checkFavorite(String tid, String uid)  async {
    bool retVal = false;
    
     QuerySnapshot query = await FirebaseFirestore.instance
        .collection('favorites')
        .where('tutor_tid', isEqualTo: tid)
        .where('student_uid', isEqualTo: uid)
        .get()
        .catchError((e) => {print(e.toString())});

      if(query.docs.isNotEmpty){
        retVal = true;
      }

      return retVal;
        
  }
}
