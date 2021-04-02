import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile/myProfile_model.dart';


class DrawerModel extends MyProfileModel {
  
  AuthServices _services = new AuthServices();



  Future<dynamic> getTutorData() async {
    User user = await _services.getCurrentUser();

    dynamic retData = null;

    DocumentReference tutorDoc = await FirebaseFirestore.instance
    .collection('tutors')
    .where('uid', isEqualTo: user.uid)
    .get().then((value){
      value.docs.forEach((element) {
        retData = element.data();
      });
    });

    return retData;


  }

  Future<Map<String,dynamic>> userProfile() async{
    User user = await _services.getCurrentUser();

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
    .doc(user.uid);

     await retVal.get().then((snapshot)async{
       var tutorData = await getTutorData();
      returnData = {
        'firstName': snapshot.data()['firstName'],
        'lastName': snapshot.data()['lastName'],
        'uid': user.uid,
        'tid': tutorData['tid'],
        'tutor_rate': tutorData['rate'],
        'tutor_majors': tutorData['majors'],
        'tutor_topics': tutorData['topics']
      };

    });


    print(returnData);
    return returnData;
  }

}