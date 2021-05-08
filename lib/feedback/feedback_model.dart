import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class FeedbackModel {

  Future<void> insertFeedback(Map<String, dynamic> feedbackContent) async {
    String fid = randomAlphaNumeric(15);
    feedbackContent['feedback_id'] = fid;
    print(feedbackContent);
    await FirebaseFirestore.instance
    .collection('feedback')
    .doc(fid)
    .set(feedbackContent);
  }

}