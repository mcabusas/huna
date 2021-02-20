import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' as Random;


class MessagesNewBookingModel {

   SharedPreferences sp;


  Future<void> createBooking(Map<String, dynamic> bookingData, Map<String, dynamic> pretestData, Map<String, dynamic> posttestData) async {
    
    String bookingId = randomAlphaNumeric(15);
    print(bookingData);
    print(bookingId);

    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .set({

      'bookingId': bookingId,
      'bookingData': bookingData,
      'pretestData': pretestData,
      'posttestData':posttestData

    }).catchError((e) => {
      print(e.toString())
    });


  }


}