import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:huna/services/auth_services.dart';


class MessagesChatModel {

  AuthServices _authServices = new AuthServices();

  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$b\_$a";
    }
  }

   getConversationMessages(String chatRoomId)  {
    
    return FirebaseFirestore.instance
    .collection('chatrooms')
    .doc(chatRoomId)
    .collection('messages')
    .orderBy('timeStamp',descending: false)
    .snapshots();

  }

  Future<void> insertMessage(String chatRoomId, String message, String sentTo) async{

    User user = await _authServices.getCurrentUser();

    Map<String, dynamic> messageMap = {
      'message': message,
      'sentBy': user.uid,
      'sentTo': sentTo,
      'timeStamp': DateTime.now().microsecondsSinceEpoch
    };

    FirebaseFirestore.instance
    .collection('chatrooms')
    .doc(chatRoomId)
    .collection('messages')
    .add(messageMap)
    .catchError((e){
      print(e.toString());
    });

  }

}