import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModal {

  Future<Map<String, dynamic>> getHistory(String uid, int flag) async {
    List<Map<String, dynamic>> docData = [];
    double totalIncome = 0.0;
    Map<String, dynamic> retData = {
      'docData': docData,
      'total_income': totalIncome
    };
    String histFlag;

    if(flag == 0){
      histFlag = 'student_id';
    }
    if(flag == 1){
      histFlag = 'tutor_userid';
    }

    QuerySnapshot bookings = await FirebaseFirestore.instance
    .collection('bookings')
    .where('bookingData.$histFlag', isEqualTo: uid)
    .where('bookingData.booking_status', isEqualTo: 'Finished')
    .get();

    for(int i = 0; i < bookings.docs.length; i++){
      String bookingid = bookings.docs[i].id;

      DocumentReference bookingsRef = FirebaseFirestore.instance
      .collection('bookings')
      .doc(bookingid);

      await bookingsRef.get().then((value){
        docData.add({
          
          'firstName': value.data()['bookingData']['tutor_firstName'],
          'lastName': value.data()['bookingData']['tutor_lastName'],
          'topic': value.data()['bookingData']['topic'],
          'timeStart': value.data()['bookingData']['timeStart'],
          'timeEnd': value.data()['bookingData']['timeEnd'],
          'location': value.data()['bookingData']['location'],
          'date': value.data()['bookingData']['date'],
          'rate': value.data()['bookingData']['rate'],

        });

        //totalIncome += value.data()['bookingData']['rate'];

      });
      
    }


    retData = {
      'docData': docData,
      'total_income': totalIncome.toString()
    };

    print(retData);


    return retData;
  }
}