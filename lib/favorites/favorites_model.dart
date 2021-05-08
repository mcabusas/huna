import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile/myProfile_model.dart';

class FavoritesModel extends MyProfileModel {

  Future<List<Map<String, dynamic>>> getFavorites(String uid) async {
    List<Map<String, dynamic>> tutors = [];
    QuerySnapshot docs = await FirebaseFirestore.instance
    .collection('favorites')
    .where('student_uid', isEqualTo: uid)
    .get();

    for(int i = 0; i < docs.docs.length; i++) {
      String docId = docs.docs[i].id;
      DocumentReference docRef = FirebaseFirestore.instance
      .collection('favorites')
      .doc(docId);

      await docRef.get().then((value) async =>  {

        await FirebaseFirestore.instance
        .collection('tutors')
        .doc(value.data()['tutor_tid'])
        .get()
        .then((value) => {
          tutors.add(value.data())
        }),
      });
    }

    return  tutors;

    
  }

  
  Future<bool> removeFavorite(String tid, String uid) async {

    bool retVal = false;

    await FirebaseFirestore.instance
    .collection('favorites')
    .where('tutor_uid', isEqualTo: tid)
    .where('student_uid', isEqualTo: uid)
    .get().then((value) => {
      value.docs.forEach((element) {
        element.reference.delete();
      }),
      retVal = true
    });


    return retVal;

  }

}