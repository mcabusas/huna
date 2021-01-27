import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DrawerModel {
  
  AuthServices _services = new AuthServices();

  Future<Map<String,dynamic>> userProfile() async{
    User user = await _services.getCurrentUser();

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

}