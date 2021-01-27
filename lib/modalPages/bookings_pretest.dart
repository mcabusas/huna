import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/modalPages/bookings_viewTutorial.dart';
import 'package:http/http.dart' as http;


// ignore: must_be_immutable
class PretestPage extends StatefulWidget {
  String totalQuestions;
  PretestPage({this.totalQuestions});

  @override
  _PretestState createState() => _PretestState();
}

class _PretestState extends State<PretestPage> {
  int selectedRadio;
  int correctRadio;
  int currentQuestion;
  int index;
  var questionObject;
  TextEditingController questionContent = new TextEditingController();
  TextEditingController firstChoice = new TextEditingController();
  TextEditingController secondChoice = new TextEditingController();
  //var questions =  [{'question1': 1, 'option1': 1, 'option2': 1, 'correctRadio': 2}, {'question2':2, 'option1': 2, 'option2': 12, 'correctRadio': 3}];


  Future insertPretest() async {
    final response = await http.get(
      Uri.encodeFull("http://www.hunacapstone.com/api/models/addQuestions.php?questions=$questionContent"),
      headers: {
        "Accept": 'application/json',
      }
    );
    if(response.statusCode == 200){
      setState(() {
        jsonData = jsonDecode(response.body);
        isLoading = true;
      });
    }
    print(jsonData);

  }

  

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    currentQuestion = 1;
    correctRadio = 0;
    index=0;
    //questions = new List(int.parse(widget.totalQuestions));
  }

  setSelectedRadio(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  setCorrectRadio(int value) {
    setState(() {
      correctRadio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Pretest'),
      ),
      body: ListView(
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
                RaisedButton.icon(
                  onPressed: () {
                    insertPretest();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Bookings()),
                    // );
                  },
                  icon: Icon(Icons.check),
                  label: Text('Finish'),
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          // IF STILL CREATING:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30.0),
                child: TextField(
                  controller: questionContent,
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
                    RadioListTile(
                      value: 1,
                      groupValue: correctRadio,
                      title: TextField(
                        controller: firstChoice,
                        decoration: InputDecoration(
                          hintText: 'Answer 1',
                        ),
                      ),
                      onChanged: (value) {
                        setCorrectRadio(value);
                      },
                      activeColor: Colors.lightGreen,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: correctRadio,
                      title: TextField(
                        controller: secondChoice,
                        decoration: InputDecoration(
                          hintText: 'Answer 2',
                        ),
                      ),
                      onChanged: (value) {
                        setCorrectRadio(value);
                      },
                      activeColor: Colors.lightGreen,
                    ),
                    RadioListTile(
                      value: 3,
                      groupValue: correctRadio,
                      title: TextField(
                        decoration: InputDecoration(
                          hintText: 'Answer 3',
                        ),
                      ),
                      onChanged: (value) {
                        setCorrectRadio(value);
                      },
                      activeColor: Colors.lightGreen,
                    ),
                    RadioListTile(
                      value: 4,
                      groupValue: correctRadio,
                      title: TextField(
                        decoration: InputDecoration(
                          hintText: 'Answer 4',
                        ),
                      ),
                      onChanged: (value) {
                        setCorrectRadio(value);
                      },
                      activeColor: Colors.lightGreen,
                    ),
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
                        setState(() {
                          if(currentQuestion != 1){
                            currentQuestion--;
                          }
                        });
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 15.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.deepPurple,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    RawMaterialButton(
                      onPressed: null,
                      child: Text(
                        currentQuestion.toString() + ' / '+ widget.totalQuestions,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ), // CURRENT PAGE NUMBER
                      shape: CircleBorder(),
                      elevation: 0,
                      // fillColor: Colors.deepPurple.shade300,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          // if(currentQuestion != questions.length){
                          //   questionObject = {
                          //     'question ' + currentQuestion.toString(): questionContent.text,
                          //     'option1': firstChoice.text,
                          //     'option2': secondChoice.text,
                          //     'correctRadio':  correctRadio.toString(),
                          //   };
                          //   questions[currentQuestion-1] = questionObject;
                          //   questionObject = {};
                          //   questionContent.clear();
                          //   firstChoice.clear();
                          //   secondChoice.clear();
                          //   correctRadio = 0;
                          //   currentQuestion++;
                          // }
                        });
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
            ],
          ),
        ],
      ),
    );
  }
}
