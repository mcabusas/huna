import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {

  Future<void> insertFeedback(Map<String, dynamic> feedbackContent) async {
    await FirebaseFirestore.instance
    .collection('feedback')
    .add(feedbackContent);
  }

}