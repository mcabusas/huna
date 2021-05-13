import 'package:flutter/material.dart';
import 'test_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class PretestPage extends StatefulWidget {
  final pretestid;
  PretestPage({this.pretestid});

  @override
  _PretestState createState() => _PretestState();
}

class _PretestState extends State<PretestPage> {
  int currentQuestion;
  final _key = GlobalKey<FormState>();
  TestModel _model = new TestModel();
  bool isLoading;
  String question, answer1, answer2, answer3, answer4, studentsAnswer = '';

  uploadPretestData() async{
    setState(() {
        isLoading = true;
      });

      Map<String, dynamic> pretestdata = {
        'question': question,
        'answer1': answer1,
        'answer2': answer2,
        'answer3': answer3,
        'answer4': answer4,
        'students_answer_pre-test': studentsAnswer,
        'students_answer_post-test': studentsAnswer
      };

      await _model.addQuestion(pretestdata, widget.pretestid).then((value) => {

        setState(() {
          isLoading = false;
        })
        
      });
  }


  

  @override
  void initState() {
    super.initState();
    //selectedRadio = 0;
    currentQuestion = 1;
    print(widget.pretestid);
  }

  // setSelectedRadio(int value) {
  //   setState(() {
  //     selectedRadio = value;
  //   });
  // }

  // setCorrectRadio(int value) {
  //   setState(() {
  //     correctRadio = value;
  //   });
  // }\

  Widget finishBtn = Container(width: 0, height: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope (
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pre-test / Post-test'),
          automaticallyImplyLeading: false
        ),
        body: isLoading == true ? Container(child: Center(child: CircularProgressIndicator())) : ListView(
          padding: EdgeInsets.all(30),
          children: <Widget>[
            // QUESTION NUMBER
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    currentQuestion.toString(),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  // ONLY APPEARS IF ON THE LAST PAGE.

                  currentQuestion > 1 ? 
                  RaisedButton.icon(
                    onPressed: () {
                      Fluttertoast.showToast(
                        msg: "Test created",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.check),
                    label: Text('Finish'),
                    color: Colors.lightGreen,
                    textColor: Colors.white,
                  )
                  :
                  Container(width: 0, height: 0),
                ],
              ),
            ),
            // IF STILL CREATING:
            Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30.0),
                    child: TextFormField(
                      validator: (val) => 
                        val.isEmpty ? 'Enter Question' : null
                      ,
                      onChanged: (val) => {
                        question = val
                      },
                      decoration: InputDecoration(
                        hintText: 'Question ' + currentQuestion.toString(),
                      ),
                    ),
                  ),
                  // RADIO SET
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (val) => 
                            val.isEmpty ? 'Enter Answer' : null
                          ,
                          onChanged: (val) => {
                            answer1 = val
                          },
                          decoration: InputDecoration(
                            hintText: 'Answer 1 (Correct Answer)',
                          ),
                        ),
                        // RadioListTile(
                        //   value: 1,
                        //   groupValue: correctRadio,
                        //   title: TextField(
                        //     controller: firstChoice,
                        //     decoration: InputDecoration(
                        //       hintText: 'Answer 1',
                        //     ),
                        //   ),
                        //   onChanged: (value) {
                        //     setCorrectRadio(value);
                        //   },
                        //   activeColor: Colors.lightGreen,
                        // ),
                        TextFormField(
                          validator: (val) => 
                            val.isEmpty ? 'Enter Answer' : null
                          ,
                          onChanged: (val) => {
                            answer2 = val
                          },
                          decoration: InputDecoration(
                            hintText: 'Answer 2',
                          ),
                        ),
                        // RadioListTile(
                        //   value: 2,
                        //   groupValue: correctRadio,
                        //   title: TextField(
                        //     controller: secondChoice,
                        //     decoration: InputDecoration(
                        //       hintText: 'Answer 2',
                        //     ),
                        //   ),
                        //   onChanged: (value) {
                        //     setCorrectRadio(value);
                        //   },
                        //   activeColor: Colors.lightGreen,
                        // ),
                        TextFormField(
                          validator: (val) => 
                            val.isEmpty ? 'Enter Answer' : null
                          ,
                          onChanged: (val) => {
                            answer3 = val
                          },
                          decoration: InputDecoration(
                            hintText: 'Answer 3',
                          ),
                        ),
                        // RadioListTile(
                        //   value: 3,
                        //   groupValue: correctRadio,
                        //   title: TextField(
                        //     decoration: InputDecoration(
                        //       hintText: 'Answer 3',
                        //     ),
                        //   ),
                        //   onChanged: (value) {
                        //     setCorrectRadio(value);
                        //   },
                        //   activeColor: Colors.lightGreen,
                        // ),
                        TextFormField(
                          validator: (val) => 
                            val.isEmpty ? 'Enter Answer' : null
                          ,
                          onChanged: (val) => {
                            answer4 = val
                          },
                          decoration: InputDecoration(
                            hintText: 'Answer 4',
                          ),
                        ),
                        // RadioListTile(
                        //   value: 4,
                        //   groupValue: correctRadio,
                        //   title: TextField(
                        //     decoration: InputDecoration(
                        //       hintText: 'Answer 4',
                        //     ),
                        //   ),
                        //   onChanged: (value) {
                        //     setCorrectRadio(value);
                        //   },
                        //   activeColor: Colors.lightGreen,
                        // ),
                      ],
                    ),
                  ),
                  // BOTTOM NAVIGATION
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        
                        RawMaterialButton(
                          onPressed: () {
                            if(_key.currentState.validate()) {
                              uploadPretestData();
                              setState(() {
                                currentQuestion++;
                              });

                            }
                            
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15.0,
                          ),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.deepPurple,
                          padding: const EdgeInsets.all(15.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text("NOTE: If you've made a mistake after submitting the question, you will still be able to edit your question after you've finished on the previous page.",
                      style: TextStyle(color: Colors.red, fontSize: 20)
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
