import 'package:cloud_firestore/cloud_firestore.dart';

class TutorialCompleteModal {

  Future<Map<String, int>> getPretestResult(String testId) async {
    Map<String, int> pretestResult = {
      'correct': 0,
      'incorrect': 0
    };
    
    QuerySnapshot questionsSnapshot;

    questionsSnapshot = await FirebaseFirestore.instance
    .collection('pretest')
    .doc(testId)
    .collection('QnA')
    .get();

    try{
      for(int i = 0 ; i < questionsSnapshot.docs.length; i++){
        if(questionsSnapshot.docs[i].data()['students_answer'] == questionsSnapshot.docs[i].data()['answer1']){
          pretestResult['correct']++;
        }else{
          pretestResult['incorrect']++;
        }
      }
    }catch(e){
      print(e.toString());
    }


    return pretestResult;

    
  } 

}