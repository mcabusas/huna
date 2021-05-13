import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/modalPages/test/option_tile.dart';
import 'package:huna/modalPages/test/question_model.dart';
import 'test_model.dart';
import 'results/results_pretestview.dart';

int _total, _correct, _incorrect_, _notAtttempted;


class AnswerPretestPage extends StatefulWidget {
  final testData;
  final flag;
  final stackFlag;
  AnswerPretestPage({this.testData, this.flag, this.stackFlag});
  @override
  _AnswerPretestState createState() => _AnswerPretestState();
}

class _AnswerPretestState extends State<AnswerPretestPage> {

  TestModel _model = new TestModel();
  QuerySnapshot questionsSnapshot;

  QuestionModel getQuestionModelFromDataSnapshot(DocumentSnapshot qSnapshot){
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = qSnapshot.data()['question'];

    List<String> options = 
    [
      qSnapshot.data()['answer1'],
      qSnapshot.data()['answer2'],
      qSnapshot.data()['answer3'],
      qSnapshot.data()['answer4'],
    ];

    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = qSnapshot.data()['answer1'];
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    super.initState();
    _model.getQuestions(widget.testData['testData']['test_id']).then((value){
      setState(() {
        questionsSnapshot = value;
        _notAtttempted = 0;
        _correct = 0;
        _incorrect_ = 0;
      _total = questionsSnapshot.docs.length;
      });
    });
    print(_total.toString() + ' sdkfjkasdjfl;');
  }

  @override
  Widget build(BuildContext context) {

    String testFlag;

    if(widget.flag == 0){
      setState(() {
        testFlag = 'Answer: Pre-test';
      });
    }else if(widget.flag == 1){
      setState(() {
        testFlag = 'Answer: Post-test';
      });
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(height: 0, width: 0,),
          // IconButton(
          // //     icon: Icon(Icons.arrow_back_ios),
          // //     onPressed: () {
          // //       Navigator.push(
          // //         context,
          // //         MaterialPageRoute(builder: (context) => Bookings()),
          // //       );
          // //     }),
          title: Text(testFlag),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          backgroundColor: Colors.blue,
          onPressed: (){
            print(widget.testData);
            _model.updatePretestStatus(widget.testData['testData']['test_id'], widget.flag).then((value){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              ResultsPage(testData: widget.testData, flag: widget.flag, stackFlag: widget.stackFlag)), (Route<dynamic> route) => false);

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ResultsPage(testData: widget.testData, flag: widget.flag)),
              // );
            });
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                questionsSnapshot == null ? 
                Container(child: Center(child: CircularProgressIndicator())):
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: questionsSnapshot.docs.length,
                  itemBuilder: (context, index){
                    return PretestTile(
                      questionModel: getQuestionModelFromDataSnapshot(questionsSnapshot.docs[index]),
                      index: index,
                      model: _model,
                      id: questionsSnapshot.docs[index].id,
                      pretestId: widget.testData['testData']['test_id'],
                      flag: widget.flag
                    );
                  },
                )
              ],
            )
          ),
        )
      ),
    );
  }
  
}
class PretestTile extends StatefulWidget {
  final QuestionModel questionModel;
  final TestModel model;
  final String id;
  final String pretestId;
  final int flag;
  final int index;
  PretestTile({this.questionModel, this.index, this.model, this.id, this.pretestId, this.flag});
  @override
  _PretestTileState createState() => _PretestTileState();
}

class _PretestTileState extends State<PretestTile> {

  String optionSelected = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${widget.index+1}  ${widget.questionModel.question}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400
            )
            ),
          SizedBox(height: 15),

          GestureDetector(
            onTap: (){
              if(!widget.questionModel.answered){

                //correct
                if(widget.questionModel.option1 == widget.questionModel.correctOption){
                  _correct+=1;
                }else{
                  _incorrect_-=1;
                }

                optionSelected = widget.questionModel.option1;
                widget.questionModel.answered = true;
                _notAtttempted -=1;
                print(optionSelected);
                print(widget.id);
                print(widget.pretestId);
                widget.model.answerQuestion(widget.id, optionSelected, widget.pretestId, widget.flag);
                setState(() {
                  
                });

              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option1,
              option: 'A',
              optionSelected: optionSelected,
            ),
          ),

          SizedBox(height: 4),

          GestureDetector(
            onTap: (){
              if(!widget.questionModel.answered){

                //correct
                if(widget.questionModel.option2 == widget.questionModel.correctOption){
                  _correct+=1;
                }else{
                  _incorrect_-=1;
                }

                optionSelected = widget.questionModel.option2;
                widget.questionModel.answered = true;
                _notAtttempted -=1;
                widget.model.answerQuestion(widget.id, optionSelected, widget.pretestId, widget.flag);
                setState(() {
                  
                });

              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option2,
              option: 'B',
              optionSelected: optionSelected,
            ),
          ),

          SizedBox(height: 4),

          GestureDetector(
            onTap: (){
              if(!widget.questionModel.answered){

                //correct
                if(widget.questionModel.option3 == widget.questionModel.correctOption){
                  _correct+=1;
                }else{
                  _incorrect_-=1;
                }

                optionSelected = widget.questionModel.option3;
                widget.questionModel.answered = true;
                _notAtttempted -=1;
                print(optionSelected);
                widget.model.answerQuestion(widget.id, optionSelected, widget.pretestId, widget.flag);
                setState(() {
                  
                });

              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option3,
              option: 'C',
              optionSelected: optionSelected,
            ),
          ),

          SizedBox(height: 4),
          
          GestureDetector(
            onTap: (){
              if(!widget.questionModel.answered){

                //correct
                if(widget.questionModel.option4 == widget.questionModel.correctOption){
                  _correct+=1;
                }else{
                  _incorrect_-=1;
                }

                optionSelected = widget.questionModel.option4;
                widget.questionModel.answered = true;
                _notAtttempted -=1;
                print(optionSelected);
                widget.model.answerQuestion(widget.id, optionSelected, widget.pretestId, widget.flag);
                setState(() {
                  
                });

              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option4,
              option: 'D',
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 20)

          // Text(widget.questionModel.option1),
          // SizedBox(height: 4),

          // Text(widget.questionModel.question),
          // SizedBox(height: 4),
        ],
      )
    );
  }
}
