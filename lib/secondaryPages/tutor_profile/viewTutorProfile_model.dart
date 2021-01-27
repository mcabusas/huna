import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:huna/services/auth_services.dart';


class ViewTutorProfileModel {

  AuthServices _authServices = new AuthServices();
  

  Future<Map<String, dynamic>> getTutorData(String tid) async {

    DocumentReference tutorRef = await FirebaseFirestore.instance
    .collection('tutors')
    .doc(tid)
    .get()
    .then((value) {
      
    });

    return null;
  }

  Future<bool> addToFavorites(String tid) async {

    bool retVal = false;

    User user = await _authServices.getCurrentUser();
    print(user.uid);
    print(tid);

    await FirebaseFirestore.instance
    .collection('favorites')
    .add(
      {
        'uid': user.uid,
        'tid': tid,
      }
    ).then((value) {
      retVal = true;
    });

    return retVal;
  }

}