import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile/myProfile_model.dart';

class DashboardModel extends MyProfileModel{

  Future<List<Map<String, dynamic>>> getTutors() async {
    List<Map<String, dynamic>> tutors = [];


     QuerySnapshot docs = await FirebaseFirestore.instance
     .collection('tutors')
     .get();

     for(int i = 0; i < docs.docs.length; i++){
      String docId = docs.docs[i].id;

      DocumentReference docRef = FirebaseFirestore.
      instance.
      collection('tutors')
      .doc(docId);

      await docRef.get().then((value) => {
        tutors.add(value.data())
      });
    }

    print(tutors);


    return tutors;
  }


}