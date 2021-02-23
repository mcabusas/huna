import 'package:cloud_firestore/cloud_firestore.dart';

class EditPretestModal {


  Stream getQuestions(String pretestId) {
    return FirebaseFirestore.instance
    .collection('test')
    .doc(pretestId)
    .collection('QnA')
    .snapshots();
  }

  Future<void> updateQuestion(Map<String, dynamic> questionData) async {
    print(questionData);
    await FirebaseFirestore.instance
    .collection('test')
    .doc(questionData['test_id'])
    .collection('QnA')
    .doc(questionData['qid'])
    .update({
      'question': questionData['question'],
      'answer1': questionData['a1'],
      'answer2': questionData['a2'],
      'answer3': questionData['a3'],
      'answer4': questionData['a4']
    }).catchError((e) => {
      print(e.toString())
    });
  }


}