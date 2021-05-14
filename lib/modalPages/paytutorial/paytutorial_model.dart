import 'package:cloud_firestore/cloud_firestore.dart';


class PaymentTutorial {


  Future<bool> payment(var data, var orderDetails, String type) async {

    bool retVal = false;
    //print(orderDetails['transactions'][0]['amount']['details']['subtotal']);

    // var order = {
    //   'subtotal': orderDetails['transactions'][0]['amount']['details']['subtotal'],
    //   'total': orderDetails['transactions'][0]['amount']['total']
    // };

    await FirebaseFirestore.instance
    .collection('transactions')
    .doc(data['bookingId'])
    .set({
      'bookingId': data['bookingId'],
      'order_details': orderDetails,
      'student_id': data['bookingData']['student_id'],
      'tutor_uid': data['bookingData']['tutor_userid'],
      'payment_type': type
    }).then((value) => {
      FirebaseFirestore.instance
      .collection('bookings')
      .doc(data['bookingId'])
      .update({
        'payment_status': true
      }),
      retVal = true
    }).catchError((e) => {
      print('error on insert payment'),
      print(e.toString())
    });

    return retVal;
  }

}