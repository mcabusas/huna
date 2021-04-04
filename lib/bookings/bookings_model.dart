import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile/myProfile_model.dart';
class BookingsModel extends MyProfileModel{

  Stream getStudentBookings(String uid) {
    return FirebaseFirestore.instance
    .collection('bookings')
    .where('bookingData.student_id', isEqualTo: uid)
    .snapshots().handleError((e)=>{
      print(e.toString())
    });
  }

  Stream getTutorBookings(String uid) {
    return FirebaseFirestore.instance
    .collection('bookings')
    .where('bookingData.tutor_userid', isEqualTo: uid)
    .snapshots().handleError((e)=>{
      print(e.toString())
    });
  }

  Future<bool> checkPretestStatus(String bookingId) async {
    bool retVal = false;
    DocumentSnapshot ref = await FirebaseFirestore.instance
    .collection('pretest')
    .doc(bookingId)
    .get();

    if(ref.exists){
      retVal = true;
    }

    return retVal;

  }

  void updateBookingStatus(String id, int flag){
    if(flag == 1){
      FirebaseFirestore.instance
      .collection('bookings')
      .doc(id)
      .update(
        {
          'bookingData.booking_status': 'Accepted'
        }
      );
    }else if(flag == 0){
      FirebaseFirestore.instance
      .collection('bookings')
      .doc(id)
      .update(
        {
          'bookingData.booking_status': 'Cancelled'
        }
      );
    }
  }


  
}