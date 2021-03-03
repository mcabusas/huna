import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesModel {

  Stream getFavorites(String uid)  {
    return FirebaseFirestore.instance
    .collection('favorites')
    .where('user_id', isEqualTo: uid)
    .snapshots().handleError((e)=>{
      print(e.toString())
    });
  }
  
  Future<bool> removeFavorite(String tid, String uid) async {

    bool retVal = false;

    await FirebaseFirestore.instance
    .collection('favorites')
    .where('tutor_id', isEqualTo: tid)
    .where('user_id', isEqualTo: uid)
    .get().then((value) => {
      value.docs.forEach((element) {
        element.reference.delete();
      }),
      retVal = true
    });


    return retVal;

  }

}