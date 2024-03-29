import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huna/services/auth_services.dart';
import '../profile/myProfile_model.dart';

class MessagesModel extends MyProfileModel {

  AuthServices _auth = new AuthServices();


  //chat rooms assigned to as a student
  Future<List<Map<String, dynamic>>> getStudentChatRooms(String uid) async {
    List<Map<String, dynamic>> retData = [];

    QuerySnapshot chatrooms = await FirebaseFirestore.instance
    .collection('chatrooms')
    .where('users.studentid', isEqualTo: uid)
    .get();

      for(int i = 0; i< chatrooms.docs.length; i++){
        String chatroomid = chatrooms.docs[i].id;

        DocumentReference chatRoomRef = FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomid);

        await chatRoomRef.get().then((snapshot){

          retData.add({
            'firstName': snapshot.data()['users']['tutor_firstName'],
            'lastName': snapshot.data()['users']['tutor_lastName'],
            'chatRoomId': snapshot.data()['chatroomid'],
            'rate': snapshot.data()['users']['tutor_rate'],
            'tid': snapshot.data()['users']['tutorid'],
            'uid': snapshot.data()['users']['tutor_userid']
            
          });


        });
      }
    print(retData);

    return retData;

  }


  //chat rooms assigned to as tutor
  Future<List<Map<String, dynamic>>> getTutorChatRooms(String uid) async {
    List<Map<String, dynamic>> retData = [];


    QuerySnapshot chatrooms = await FirebaseFirestore.instance
    .collection('chatrooms')
    .where('users.tutor_userid', isEqualTo: uid)
    .get();

    for(int i = 0; i< chatrooms.docs.length; i++){
      String chatroomid = chatrooms.docs[i].id;
      print(chatroomid);

      DocumentReference chatRoomRef = FirebaseFirestore.instance
      .collection('chatrooms')
      .doc(chatroomid);

      await chatRoomRef.get().then((snapshot){

        retData.add({
          'firstName': snapshot.data()['users']['student_firstName'],
          'lastName': snapshot.data()['users']['student_lastName'],
          'chatRoomId': snapshot.data()['chatroomid'],
          'rate': snapshot.data()['users']['tutor_rate'],
          'uid': snapshot.data()['users']['studentid'],
          
        });


      });
    }

    print(retData);
    

    return retData;

  }

}