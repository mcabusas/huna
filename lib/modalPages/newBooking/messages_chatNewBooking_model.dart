import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' as Random;


class MessagesNewBookingModel {

   SharedPreferences sp;


  Future<void> createBooking(Map<String, dynamic> bookingData, Map<String, dynamic> testData) async {
    
    String bookingId = randomAlphaNumeric(15);
    print(bookingData);
    print(bookingId);

    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .set({

      'bookingId': bookingId,
      'bookingData': bookingData,
      'testData': testData,
      

    }).catchError((e) => {
      print(e.toString())
    });


  }


}