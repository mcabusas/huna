import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences sp;


  Future<User> getCurrentUser() async {
    User user = await (_auth.currentUser);
    return user;
  }
  String getCurrentUserId()  {
    User user = _auth.currentUser;
    return user.uid;
  }

  Future<bool> login(String email, String password) async{
    final User user = (await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    )).user;

    notifyListeners();

    if(user != null){
      userProfile(user.uid);

      return true;
    }else{
      return false;
    }
  }

  Future userProfile(String uid) async{

    sp = await SharedPreferences.getInstance();

    Map<String, dynamic> returnData = {
      'firstName': '',
      'lastName': '',
      'uid': '',
      'tid': '',
      'rate': '',
      'majors': '',
      'topics': ''
    };


    DocumentReference retVal =  FirebaseFirestore.instance
    .collection('users')
    .doc(uid);

     await retVal.get().then((snapshot)async{

       returnData['firstName'] = snapshot.data()['firstName'];
       returnData['lastName'] = snapshot.data()['lastName'];
       returnData['uid'] = snapshot.data()['uid'];

       await FirebaseFirestore.instance
       .collection('tutors')
       .where('uid', isEqualTo: uid)
       .get().then((value) => {
         if(value.docs.length != 0){
           value.docs.forEach((element) {
             print(element.data()['rate']);
            returnData['tid'] = element.data()['tid'];
            returnData['tutor_rate'] = element.data()['rate'];
            returnData['tutor_majors'] = element.data()['majors'];
            returnData['tutor_topics'] = element.data()['topics'];
            // returnData = {
            //   'tid': element.data()['tid'],
            //   'tutor_rate': element.data()['rate'],
            //   'tutor_majors': element.data()['majors'],
            //   'tutor_topics': element.data()['topics']
            // };

          })
         }
       });

      setPref(returnData);

    });


    //print(returnData);

  }

  Future setPref(Map<String, dynamic> data)async{

    sp = await SharedPreferences.getInstance();
    print(data);
      await sp.setString('firstName', data['firstName']);
      sp.setString('lastName', data['lastName']);
      sp.setString('uid', data['uid']);
      sp.setString('tid', data['tid']);
      sp.setString('rate', data['tutor_rate']);

      print(sp.getString('rate'));
  }

  Future<dynamic> getTutorData() async {
    User user = await _auth.currentUser;

    dynamic retData = null;

    DocumentReference tutorDoc = await FirebaseFirestore.instance
    .collection('tutors')
    .where('uid', isEqualTo: user.uid)
    .get().then((value){
      value.docs.forEach((element) {
        retData = element.data();
      });
    });

    print(retData);

    return retData;


  }

  Future<void> register(Map<String, String> data) async{

    try{


      UserCredential retVal  = await _auth.createUserWithEmailAndPassword(email: data['email'], password: data['password']);
      
      data['uid'] = retVal.user.uid;
      data['tid'] = '';

      FirebaseFirestore.instance
      .collection('users')
      .doc(retVal.user.uid)
      .set(data);


      return;
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Future<void> signOut() async {
    sp = await SharedPreferences.getInstance();
    await _auth.signOut();
    await sp.clear().catchError((e) => {
      print(e.toString())
    });
    notifyListeners();

  }



}