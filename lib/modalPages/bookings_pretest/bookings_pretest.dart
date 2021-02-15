import 'package:flutter/material.dart';
import 'bookings_pretest_model.dart';


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
  PretestModel _model = new PretestModel();
  bool isLoading;
  String question, answer1, answer2, answer3, answer4, studentsAnswer = '';

  uploadPretestData() async{
    if(_key.currentState.validate()){
      
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> pretestdata = {
        'question': question,
        'answer1': answer1,
        'answer2': answer2,
        'answer3': answer3,
        'answer4': answer4,
        'students_answer': studentsAnswer
      };

      await _model.addQuestion(pretestdata, widget.pretestid).then((value) => {

        setState(() {
          isLoading = false;
        })
        
      });
    }
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
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pretest'),
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
                RaisedButton.icon(
                  onPressed: () {
                    //insertPretest();
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
                        // child: Text(
                        //   currentQuestion.toString() + ' / '+ widget.totalQuestions,
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 20),
                        // ), // CURRENT PAGE NUMBER
                        shape: CircleBorder(),
                        elevation: 0,
                        // fillColor: Colors.deepPurple.shade300,
                        padding: const EdgeInsets.all(15.0),
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          uploadPretestData();
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
          ),
        ],
      ),
    );
  }
}
