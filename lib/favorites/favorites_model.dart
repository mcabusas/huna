import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile/myProfile_model.dart';

class FavoritesModel extends MyProfileModel {

  Stream getFavorites(String uid)  {
    return FirebaseFirestore.instance
    .collection('favorites')
    .where('student_uid', isEqualTo: uid)
    .snapshots().handleError((e)=>{
      print(e.toString())
    });
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