import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthServices with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User> getCurrentUser() async {
    User user = await (_auth.currentUser);
    return user;
  }

  Future<bool> login(String email, String password) async{
    final User user = (await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    )).user;

    notifyListeners();

    if(user != null){
      return true;
    }else{
      return false;
    }
  }

  Future<Map<String,dynamic>> userProfile() async{
    User user = await _auth.currentUser;

    Map<String, dynamic> returnData;

    DocumentReference retVal =  FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid);

     await retVal.get().then((snapshot){
      returnData = snapshot.data();
    });

    //print(returnData);
    return returnData;

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
    await _auth.signOut();
    notifyListeners();

  }



}