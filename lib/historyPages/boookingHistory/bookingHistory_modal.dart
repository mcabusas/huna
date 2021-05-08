import 'package:cloud_firestore/cloud_firestore.dart';
import '../../profile/myProfile_model.dart';
class HistoryModal extends MyProfileModel {


  Future<Map<String, dynamic>> getTutorsHistory(String uid) async {
    List<Map<String, dynamic>> docData = [];
    double totalIncome = 0.0;
    Map<String, dynamic> retData = {};
    var rate;

    QuerySnapshot bookings = await FirebaseFirestore.instance
    .collection('bookings')
    .where('bookingData.tutor_userid', isEqualTo: uid)
    .get();

    for(int i = 0; i < bookings.docs.length; i++){
      String bookingid = bookings.docs[i].id;

      DocumentReference bookingsRef = FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingid);

      await bookingsRef.get().then((value){
        docData.add({
          'uid': value.data()['bookingData']['student_id'],
          'firstName': value.data()['bookingData']['student_firstName'],
          'lastName': value.data()['bookingData']['student_lastName'],
          'topic': value.data()['bookingData']['topic'],
          'timeStart': value.data()['bookingData']['timeStart'],
          'timeEnd': value.data()['bookingData']['timeEnd'],
          'location': value.data()['bookingData']['location'],
          'date': value.data()['bookingData']['date'],
          'rate': value.data()['bookingData']['rate'],
          'status': value.data()['bookingData']['booking_status']

        });

        if(value.data()['bookingData']['booking_status'] == 'Declined' || value.data()['bookingData']['booking_status'] == 'Cancelled') {
          rate = 0;
        } else{
          rate = double.parse(value.data()['bookingData']['rate']);
        }

        totalIncome += rate;

      });
      
    }


    retData = {
      'docData': docData,
      'total': totalIncome
    };

    print(retData);


    return retData;
  }

  Future<Map<String, dynamic>> getStudentHistory(String uid) async {
    List<Map<String, dynamic>> docData = [];
    double totalIncome = 0.0;
    Map<String, dynamic> retData = {};
    var rate;

    QuerySnapshot bookings = await FirebaseFirestore.instance
    .collection('bookings')
    .where('bookingData.student_id', isEqualTo: uid)
    .get();

    for(int i = 0; i < bookings.docs.length; i++){
      String bookingid = bookings.docs[i].id;

      DocumentReference bookingsRef = FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingid);

      await bookingsRef.get().then((value){
        docData.add({
          'uid': value.data()['bookingData']['tutor_userid'],
          'firstName': value.data()['bookingData']['tutor_firstName'],
          'lastName': value.data()['bookingData']['tutor_lastName'],
          'topic': value.data()['bookingData']['topic'],
          'timeStart': value.data()['bookingData']['timeStart'],
          'timeEnd': value.data()['bookingData']['timeEnd'],
          'location': value.data()['bookingData']['location'],
          'date': value.data()['bookingData']['date'],
          'rate': value.data()['bookingData']['rate'],
          'status': value.data()['bookingData']['booking_status']

        });
        if(value.data()['bookingData']['booking_status'] == 'Declined' || value.data()['bookingData']['booking_status'] == 'Cancelled') {
          rate = 0;
        } else{
          rate = double.parse(value.data()['bookingData']['rate']);
        }

        totalIncome += rate;

      });
      
    }


    retData = {
      'docData': docData,
      'total': totalIncome
    };

    print(retData);


    return retData;
  }
}