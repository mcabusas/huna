import 'package:cloud_firestore/cloud_firestore.dart';


class TutorialInSessionModal {

  Future<void> endTutorial(String bookingId) async {
    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .update({

      'bookingData.booking_status': 'Finished'
      
    }).catchError((e) => {
      print(e.toString())
    });
  }

  Future<void> reportSos(String bookingId) async {
    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .update({
      'bookingData.booking_status': 'Cancelled',
      'sos': 'active'
    }).catchError((e){
      print('error in model');
    });
  }


}