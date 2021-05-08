import 'package:cloud_firestore/cloud_firestore.dart';
import '../../profile/myProfile_model.dart';

class ViewTutorialModel extends MyProfileModel {

  Stream getStatus(String bookingId){
    return FirebaseFirestore.instance
    .collection('bookings')
    .where('bookingId', isEqualTo: bookingId)
    .snapshots()
    .handleError((onError) => {
      print(onError.toString())
    });
  }

  Future<void> createPretest(Map<String, dynamic> testInfo) async {
    await FirebaseFirestore.instance
    .collection('test')
    .doc(testInfo['pretest_id'])
    .set(testInfo)
    .catchError((e) => {
      print(e.toString())
    }).then((value) {

       FirebaseFirestore.instance
        .collection('bookings')
        .doc(testInfo['pretest_id'])
        .update({
          'testData.test_id': testInfo['pretest_id'],
        }).catchError((e) => {
          print(e.toString())
        });

    });
  }

  Future<bool> updateSentStatus(String bookingId) async {
    bool retVal = false;
    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .update({
      'testData.test_sentStatus': '1'
    }).then((value) => {
      retVal = true
    }).catchError((e) => {
      print(e.toString())
    });

    return retVal;
  }

  Future<void> beginTutorial(String bookingId) async {
    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .update({
      'bookingData.booking_status': 'Ongoing'
    }).catchError((e) => {
      print(e.toString())
    });
  }

 


}