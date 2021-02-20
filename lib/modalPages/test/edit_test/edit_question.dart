import 'package:flutter/material.dart';
import 'edit_testmodal.dart';


class EditQuestion extends StatefulWidget {
  final questionData;
  EditQuestion({this.questionData});
  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {

  final _key = GlobalKey<FormState>();
  EditPretestModal _modal = new EditPretestModal();
  bool isLoading;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Question'),
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
                // Text(
                //   currentQuestion.toString(),
                //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                // ),
                // ONLY APPEARS IF ON THE LAST PAGE.
                RaisedButton.icon(
                  onPressed: () async {
                    _modal.updateQuestion(widget.questionData).then((value) => {
                      Navigator.pop(context)
                    });
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
                    initialValue: widget.questionData['question'],
                    validator: (val) => 
                      val.isEmpty ? 'Enter Question' : null
                    ,
                    onChanged: (val) => {
                      widget.questionData['question'] = val
                    },
                    decoration: InputDecoration(
                      hintText: 'Question',
                    ),
                  ),
                ),
                // RADIO SET
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: widget.questionData['a1'],
                        validator: (val) => 
                          val.isEmpty ? 'Enter Answer' : null
                        ,
                        onChanged: (val) => {
                          widget.questionData['a1'] = val
                        },
                        decoration: InputDecoration(
                          hintText: 'Answer 1 (Correct Answer)',
                        ),
                      ),
                      TextFormField(
                        initialValue: widget.questionData['a2'],
                        validator: (val) => 
                          val.isEmpty ? 'Enter Answer' : null
                        ,
                        onChanged: (val) => {
                          widget.questionData['a2'] = val
                        },
                        decoration: InputDecoration(
                          hintText: 'Answer 2',
                        ),
                      ),
                      TextFormField(
                        initialValue: widget.questionData['a3'],
                        validator: (val) => 
                          val.isEmpty ? 'Enter Answer' : null
                        ,
                        onChanged: (val) => {
                          widget.questionData['a3'] = val
                        },
                        decoration: InputDecoration(
                          hintText: 'Answer 3',
                        ),
                      ),
                      TextFormField(
                        initialValue: widget.questionData['a4'],
                        validator: (val) => 
                          val.isEmpty ? 'Enter Answer' : null
                        ,
                        onChanged: (val) => {
                          widget.questionData['a4'] = val
                        },
                        decoration: InputDecoration(
                          hintText: 'Answer 4',
                        ),
                      ),
                      
                      SizedBox(height: 25),

                      Text(
                        'Note: answer 1 is still your correct answer',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16
                        ),
                      )
                    ],
                  ),
                ),
                // BOTTOM NAVIGATION
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}