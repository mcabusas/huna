import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTutorialModel {

  Future<void> createPretest(Map<String, dynamic> pretestInfo) async {
    await FirebaseFirestore.instance
    .collection('pretest')
    .doc(pretestInfo['pretest_id'])
    .set(pretestInfo)
    .catchError((e) => {
      print(e.toString())
    }).then((value) {

      FirebaseFirestore.instance
      .collection('posttest')
      .doc(pretestInfo['pretest_id'])
      .set(pretestInfo)
      .then((value) => {

        FirebaseFirestore.instance
        .collection('bookings')
        .doc(pretestInfo['pretest_id'])
        .update({
          'pretestData.pretest_id': pretestInfo['pretest_id'],
          'posttestData.posttest_id': pretestInfo['pretest_id']
        }).catchError((e) => {
          print(e.toString())
        })

      });
    });
  }

  Future<void> updateSentStatus(String bookingId) async {
    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .update({
      'pretestData.pretest_sentStatus': '1',
      'posttestData.posttest_sentStatus': '1'
    }).catchError((e) => {
      print(e.toString())
    });
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