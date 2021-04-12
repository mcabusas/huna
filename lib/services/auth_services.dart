import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences sp;
  FirebaseMessaging _firebaseMessaging;

  Stream getTutorTag(String uid) {
    return FirebaseFirestore.instance
        .collection('tutors')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  Future<User> getCurrentUser() async {
    User user = await (_auth.currentUser);
    return user;
  }

  String getCurrentUserId() {
    User user = _auth.currentUser;
    return user.uid;
  }

  Future<bool> login(String email, String password) async {
    final User user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    notifyListeners();

    if (user != null) {
      userProfile(user.uid);

      return true;
    } else {
      return false;
    }
  }

  Map<String, dynamic> userProfile(String uid) {
    //sp = await SharedPreferences.getInstance();
    _firebaseMessaging = new FirebaseMessaging();

    List deviceTokens = [];

    Map<String, dynamic> returnData = {
      'firstName': '',
      'lastName': '',
      'uid': '',
      'tid': '',
      'rate': '',
      'city': '',
      'country': '',
      'majors': [],
      'topics': [],
      'zipCode': '',
      'homeAddress': '',
      'contactNumber': '',
      'emergencyFirstName': '',
      'emergencyLastName': '',
      'emergencyRelation': '',
      'emergencyContactNumber': ''
    };

    DocumentReference retVal =
        FirebaseFirestore.instance.collection('users').doc(uid);

    retVal.get().then((snapshot) async {
      returnData['firstName'] = snapshot.data()['firstName'];
      returnData['lastName'] = snapshot.data()['lastName'];
      returnData['uid'] = snapshot.data()['uid'];
      returnData['city'] = snapshot.data()['city'];
      returnData['country'] = snapshot.data()['country'];
      returnData['homeAddress'] = snapshot.data()['homeAddress'];
      returnData['zipCode'] = snapshot.data()['zipCode'];
      returnData['contactNumber'] = snapshot.data()['contactNumber'];
      returnData['emergencyFirstName'] = snapshot.data()['emergencyFirstName'];
      returnData['emergencyLastName'] = snapshot.data()['emergencyLastName'];
      returnData['emergencyContactNumber'] =
          snapshot.data()['emergencyContactNumber'];
      returnData['emergencyRelation'] = snapshot.data()['emergencyRelation'];
       List.from(snapshot.data()['device_tokens']).forEach((element){
          deviceTokens.add(element);
      });

      await FirebaseFirestore.instance
          .collection('tutors')
          .where('uid', isEqualTo: returnData['uid'])
          .get()
          .then((value) => {
                if (value.docs.length != 0)
                  {
                    value.docs.forEach((element) {
                      returnData['tid'] = element.data()['tid'];
                      returnData['rate'] = element.data()['rate'];
                      returnData['majors'] = element.data()['majors'];
                      returnData['topics'] = element.data()['topics'];
                    })
                  }
              });

      setPref(returnData);
    });

    _firebaseMessaging.getToken().then((value) => {
      print(value),
      print(deviceTokens),
      //deviceTokens[deviceTokens.length] = value,
      // retVal.update({
      //   'device_tokens': deviceTokens
      // }).catchError((e) => {
      //   print('update error: ' + e.toString())
      // })
    }).catchError((e) => {
      print(e.toString())
    });

    


    print(returnData);
    return returnData;
  }

  Future setPref(Map<String, dynamic> data) async {
    sp = await SharedPreferences.getInstance();
    sp.setString('firstName', data['firstName']);
    sp.setString('lastName', data['lastName']);
    sp.setString('uid', data['uid']);
    sp.setString('tid', data['tid']);
    sp.setString('rate', data['rate']);
    sp.setString('country', data['country']);
    sp.setString('city', data['city']);
    sp.setString('homeAddress', data['homeAddress']);
    sp.setString('emergencyFirstName', data['emergencyFirstName']);
    sp.setString('emergencyLastName', data['emergencyLastName']);
    sp.setString('contactNumber', data['contactNumber']);
    sp.setString('emergencyContactNumber', data['emergencyContactNumber']);
    sp.setString('emergencyRelation', data['emergencyRelation']);
    sp.setString('zipCode', data['zipCode']);
  }

  Future<dynamic> getTutorData() async {
    User user = await _auth.currentUser;

    dynamic retData = null;

    DocumentReference tutorDoc = await FirebaseFirestore.instance
        .collection('tutors')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        retData = element.data();
      });
    });

    print(retData);

    return retData;
  }

  Future<void> register(Map<String, String> data) async {
    try {
      UserCredential retVal = await _auth.createUserWithEmailAndPassword(
          email: data['email'], password: data['password']);

      data['uid'] = retVal.user.uid;
      data['tid'] = '';

      FirebaseFirestore.instance
          .collection('users')
          .doc(retVal.user.uid)
          .set(data);

      return;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    sp = await SharedPreferences.getInstance();
    await _auth.signOut();
    await sp.clear().catchError((e) => {print(e.toString())});
    notifyListeners();
  }
}
