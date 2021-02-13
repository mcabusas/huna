import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTutorialModel {

  Future<void> createPretest(Map<String, dynamic> pretestInfo) async {
    await FirebaseFirestore.instance
    .collection('pretest')
    .doc(pretestInfo['pretest_id'])
    .set(pretestInfo)
    .catchError((e) => {
      print(e.toString())
    }); 
  }

  Future<void> addQuestion(Map<String, dynamic> questions, String pretestid) async {
    
    await FirebaseFirestore.instance
    .collection('pretest')
    .doc(pretestid)
    .collection('QnA')
    .add(questions)
    .catchError((e) => {
      print(e.toString())
    });
    
    return null;
  }


}