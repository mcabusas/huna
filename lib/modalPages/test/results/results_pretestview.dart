import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/dashboard/dashboard.dart';
import '../test_model.dart';
import 'results.dart';
import '../../tutorialComplete/tutorial_complete.dart';

class ResultsPage extends StatefulWidget {
  final testData;
  final flag;
  final stackFlag;
  ResultsPage({this.testData, this.flag, this.stackFlag});
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  TestModel _model = new TestModel();
  QuerySnapshot questionSnapshot;

  Results getResults(DocumentSnapshot qSnapshot) {
    Results resultsModel = new Results();

    if (widget.flag == 0) {
      resultsModel.studentsAnswer =
          qSnapshot.data()['students_answer_pre-test'];
    } else if (widget.flag == 1) {
      resultsModel.studentsAnswer =
          qSnapshot.data()['students_answer_post-test'];
    }

    resultsModel.question = qSnapshot.data()['question'];
    resultsModel.correctAnswer = qSnapshot.data()['answer1'];
    //resultsModel.studentsAnswer = qSnapshot.data()['students_answer_pre-test'];

    return resultsModel;
  }

  @override
  void initState() {
    print(widget.stackFlag.toString() + ': stackFlag');
    print(widget.flag.toString() + ": flag");
    super.initState();
    _model.getQuestions(widget.testData['testData']['test_id']).then((value) {
      setState(() {
        questionSnapshot = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String testFlag = '';

    if (widget.flag == 0) {
      setState(() {
        testFlag = 'Pre-test';
      });
    } else if (widget.flag == 1) {
      setState(() {
        testFlag = 'Post-test';
      });
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            // leading: IconButton(
            //     icon: Icon(Icons.arrow_back_ios),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     }),
            title: Text('Results Page - $testFlag'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check),
            backgroundColor: Colors.blue,
            onPressed: () {
              print(widget.testData);
              print(widget.stackFlag);
              if (widget.flag == 0) {

                if(widget.stackFlag == 0){
                    Navigator.pop(context);
                }
                if(widget.stackFlag == 1 || widget.stackFlag == 2){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  DashboardPage()), (Route<dynamic> route) => false);
                }
                
                
              }else if(widget.flag == 1){
                
                if (widget.stackFlag == 0){
                    Navigator.pop(context);
                } if(widget.stackFlag == 2){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  TutorialComplete(data: widget.testData, flag: 0)), (Route<dynamic> route) => false);
                }
              }
            },
          ),
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    questionSnapshot == null
                        ? Container(
                            child: Center(child: CircularProgressIndicator()))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: questionSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              return ResultsTile(
                                results: getResults(questionSnapshot.docs[index]),
                                index: index,
                                // model: _model,
                                // id: questionSnapshot.docs[index].id,
                                // testData: widget.testData
                              );
                            },
                          )
                  ],
                )),
          )),
    );
  }
}

class ResultsTile extends StatefulWidget {
  final Results results;
  final int index;
  ResultsTile({this.results, this.index});
  @override
  _ResultsTileState createState() => _ResultsTileState();
}

class _ResultsTileState extends State<ResultsTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Q${widget.index + 1}) ${widget.results.question}',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 15),
        Text('Correct Answer: ${widget.results.correctAnswer}',
            style: TextStyle(fontSize: 17, color: Colors.black)),
        SizedBox(
          height: 15,
        ),
        Text("Student's Answer: ${widget.results.studentsAnswer}",
            style: TextStyle(fontSize: 17, color: Colors.black)),
        SizedBox(height: 15),
        widget.results.correctAnswer == widget.results.studentsAnswer
            ? Text(
                'Correct',
                style: TextStyle(color: Colors.green, fontSize: 15),
              )
            : Text(
                'Incorrect',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
        SizedBox(height: 15),
        Divider()
      ],
    ));
  }
}
