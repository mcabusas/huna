import 'package:cloud_firestore/cloud_firestore.dart';

class BookingsModel {

  Stream fetchBookings() {
    return FirebaseFirestore.instance
    .collection('bookings')
    .where('tid', isEqualTo: '10')
    .snapshots();
  }

  void updateBookingStatus(String id, int flag){
    if(flag == 1){
      FirebaseFirestore.instance
      .collection('bookings')
      .doc(id)
      .update(
        {
          'booking_status': 'Accepted'
        }
      );
    }else if(flag == 0){
      FirebaseFirestore.instance
      .collection('bookings')
      .doc(id)
      .update(
        {
          'booking_status': 'Cancelled'
        }
      );
    }
  }


  
}