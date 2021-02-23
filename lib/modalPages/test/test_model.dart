import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class TestModel{

  Future<void> addQuestion(Map<String, dynamic> questions, String pretestid) async {

    String questionId = randomAlphaNumeric(15);
    
    await FirebaseFirestore.instance
    .collection('test')
    .doc(pretestid)
    .collection('QnA')
    .doc(questionId)
    .set(questions)
    // .
    // then((value) => {
    //   FirebaseFirestore.instance
    //   .collection('posttest')
    //   .doc(pretestid)
    //   .collection('QnA')
    //   .doc(questionId)
    //   .set(questions)
    // })
    .catchError((e) => {
      print(e.toString())
    });
    
    return null;
  }

  Future<void> answerQuestion(String questionId, String answer, String pretestId, int flag) async {

    String testFlag;

    if(flag == 0){
      testFlag = 'students_answer_pre-test';
    }else if(flag == 1){
      testFlag = 'students_answer_post-test';
    }

    await FirebaseFirestore.instance
    .collection('test')
    .doc(pretestId)
    .collection('QnA')
    .doc(questionId)
    .update({
      testFlag: answer
    });
    
  }

  Future<void> updatePretestStatus(String bookingId, int flag) async {

    String testFlag;
    
    if(flag == 0){
      testFlag = 'testData.pretest_answeredStatus';
    }else if(flag == 1){
      testFlag = 'testData.posttest_answeredStatus';
    }

    await FirebaseFirestore.instance
    .collection('bookings')
    .doc(bookingId)
    .update({
      testFlag: '1'
    });
  }


  Future getQuestions(String testId) async {

    return await FirebaseFirestore.instance
    .collection('test')
    .doc(testId)
    .collection('QnA')
    .get().catchError((e) => {
      print(e.toString())
    });
  }


}