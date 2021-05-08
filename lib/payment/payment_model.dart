import 'package:cloud_firestore/cloud_firestore.dart';


class PaymentModel {

  Future<bool> addCard(String uid, String token) async {
    bool retVal = false;

    await FirebaseFirestore.instance
    .collection('cards')
    .doc(uid)
    .collection('tokens')
    .add({
      'tokenId': token
    }).then((value) => {
      retVal = true
    });

    return retVal;
    
  }

}