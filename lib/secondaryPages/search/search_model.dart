import 'package:cloud_firestore/cloud_firestore.dart';
import '../../profile/myProfile_model.dart';

class SearchModel extends MyProfileModel{

  Future<List<Map<String, dynamic>>> getTutors(String value) async {
    List<Map<String, dynamic>> tutors = [];


     QuerySnapshot docs = await FirebaseFirestore.instance
     .collection('tutors')
     .where("languages", arrayContains: value)
     .get();

     print(docs.docs.length);
  }

}