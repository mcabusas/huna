import 'package:cloud_firestore/cloud_firestore.dart';

class TutorialCompleteModal {

  Future<Map<String, int>> getPretestResult(String testId) async {
    Map<String, int> pretestResult = {
      'pre-correct': 0,
      'post-correct': 0,
      'total': 0
    };
    
    QuerySnapshot questionsSnapshot;

    questionsSnapshot = await FirebaseFirestore.instance
    .collection('test')
    .doc(testId)
    .collection('QnA')
    .get();

    try{
      for(int i = 0 ; i < questionsSnapshot.docs.length; i++){
        if(questionsSnapshot.docs[i].data()['students_answer_pre-test'] == questionsSnapshot.docs[i].data()['answer1'] && questionsSnapshot.docs[i].data()['students_answer_post-test'] == questionsSnapshot.docs[i].data()['answer1']){
          pretestResult['pre-correct']++;
          pretestResult['post-correct']++;
        } else if(questionsSnapshot.docs[i].data()['students_answer_pre-test'] == questionsSnapshot.docs[i].data()['answer1']){
          pretestResult['pre-correct']++;
        }else if(questionsSnapshot.docs[i].data()['students_answer_post-test'] == questionsSnapshot.docs[i].data()['answer1']){
          pretestResult['post-correct']++;
        }

        pretestResult['total'] = questionsSnapshot.docs.length;
      }
    }catch(e){
      print(e.toString());
    }


    return pretestResult;

    
  } 

}