import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesNewBookingModel {

   SharedPreferences sp;


  Future<void> createBooking(Map<String, dynamic> bookingData, String bookingId) async {
    
    print(bookingData);
    print(bookingId);

    // Map<String, dynamic> data = {
    //   'bookingId': bookingId,
    //   'bookingData': {
    //     bookingId
    //   }
    // };

    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .set({

      'bookingId': bookingId,
      'bookingData': bookingData

    }).catchError((e) => {
      print(e.toString())
    });


  }


}