import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile/myProfile_model.dart';

class DashboardModel extends MyProfileModel{


  Stream getTutors()   {

    Stream retStream;

    retStream = FirebaseFirestore.instance
    .collection('tutors')
    .snapshots();


    return retStream;


  }

  //Stream<List<Map<String, dynamic>>>> getTutors() async{
  //   List<Map<String,dynamic>> retData = [];

  //   QuerySnapshot tutorDocs = await FirebaseFirestore.instance
  //   .collection('tutors')
  //   .get();

  //   for(int i = 0; i < tutorDocs.docs.length; i++){
  //     var tid = tutorDocs.docs[i].id;
      
  //     DocumentReference tutorRef =  FirebaseFirestore.instance
  //     .collection('tutors')
  //     .doc(tid);

  //     await tutorRef.get().then((snapshot) async {
  //       DocumentReference userRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(snapshot.data()['uid']);
  //       String rate = snapshot.data()['rate'];
  //       String majors = snapshot.data()['majors'];
  //       String topics = snapshot.data()['topics'];

  //       await userRef.get().then((snapshot) => {

  //         //print(snapshot.data()),

  //         // holderData['firstName'] = snapshot.data()['firstName'],
  //         // holderData['lastName'] = snapshot.data()['lastName'],
  //         // holderData['username'] = snapshot.data()['username'],

  //         // print(holderData),

  //         retData.add({
  //           'firstName': snapshot.data()['firstName'],
  //           'lastName': snapshot.data()['lastName'],
  //           'username': snapshot.data()['username'],
  //           'tid': tid,
  //           'rate': rate,
  //           'majors': majors,
  //           'topics': topics,
  //           'uid': snapshot.data()['uid']
  //         }),
  //       });
  //     });

      
  //   }

  //   //print(retData);

  //   return retData;

  // }


}