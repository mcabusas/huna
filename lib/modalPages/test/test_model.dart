import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class TestModel{

  Future<void> addQuestion(Map<String, dynamic> questions, String pretestid) async {

    String questionId = randomAlphaNumeric(15);
    
    await FirebaseFirestore.instance
    .collection('pretest')
    .doc(pretestid)
    .collection('QnA')
    .doc(questionId)
    .set(questions)
    .then((value) => {
      FirebaseFirestore.instance
      .collection('posttest')
      .doc(pretestid)
      .collection('QnA')
      .doc(questionId)
      .set(questions)
    }).catchError((e) => {
      print(e.toString())
    });
    
    return null;
  }

  Future<void> answerQuestion(String questionId, String answer, String pretestId) async {

    await FirebaseFirestore.instance
    .collection('pretest')
    .doc(pretestId)
    .collection('QnA')
    .doc(questionId)
    .update({
      'students_answer': answer
    });
    
  }

  Future<void> updatePretestStatus(String bookingId) async {
    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .update({
      'pretestData.pretest_answeredStatus': '1'
    });
  }


  Future getQuestions(String pretestId) async {

    return await FirebaseFirestore.instance
    .collection('pretest')
    .doc(pretestId)
    .collection('QnA')
    .get().catchError((e) => {
      print(e.toString())
    });
  }


}