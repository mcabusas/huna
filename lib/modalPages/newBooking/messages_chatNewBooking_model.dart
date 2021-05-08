import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import '../../profile/myProfile_model.dart';
import 'dart:math' as Random;


class MessagesNewBookingModel extends MyProfileModel {

   SharedPreferences sp;


  Future<bool> createBooking(Map<String, dynamic> bookingData, Map<String, dynamic> testData) async {
    bool retVal = false;
    String bookingId = randomAlphaNumeric(15);
    print(bookingData);
    print(bookingId);

    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .set({
      'payment_status': false,
      'bookingId': bookingId,
      'bookingData': bookingData,
      'sos': 'inactive',
      'testData': testData,
      

    }).then((value) => {

      FirebaseFirestore.instance
      .collection('reviews')
      .doc(bookingId)
      .set({
        'bookingId': bookingId,
        's_uid': bookingData['student_id'],
        'student_rating': 0,
        'student_review': '',
        't_uid': bookingData['tutor_userid'],
        'tutor_rating': 0,
        'tutor_review': ''
      }),

      retVal = true

    }).catchError((e) => {
      print(e.toString())
    });

    return retVal;


  }


}