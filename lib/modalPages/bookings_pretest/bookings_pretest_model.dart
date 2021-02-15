import 'package:cloud_firestore/cloud_firestore.dart';


class PretestModel{

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
      'bookingData.pretest_status': '1'
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