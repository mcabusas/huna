import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huna/drawer/drawer.dart';
import 'feedback_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {

  FeedbackModel _model = new FeedbackModel();
  SharedPreferences sp;

  bool rate1 = false; // Very Bad
  bool rate2 = false;
  bool rate3 = false;
  bool rate4 = false;
  bool rate5 = false; // Very Good
  int rate;
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> feedbackContent = {
    'content': '',
    'rating': 0,
    'uid': ''
  };

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      feedbackContent['uid'] = sp.getString('uid');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAwait();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false, // Prevents overflowing
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      drawer: SideDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'We want to hear from you.',
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Send us your suggestions and concerns. We'll get back to you as soon as we can.",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Reactions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.sentiment_very_dissatisfied, size: 40),
                        color: rate1 ? Colors.red.shade800 : Colors.grey.shade900,
                        onPressed: () {
                          setState(() {
                            rate1 = !rate1;
                            rate2 = false;
                            rate3 = false;
                            rate4 = false;
                            rate5 = false;
                            feedbackContent['rating'] = 1;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.sentiment_dissatisfied, size: 40),
                        color:
                            rate2 ? Colors.amber.shade800 : Colors.grey.shade900,
                        onPressed: () {
                          setState(() {
                            rate1 = false;
                            rate2 = !rate2;
                            rate3 = false;
                            rate4 = false;
                            rate5 = false;
                            feedbackContent['rating'] = 2;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.sentiment_neutral, size: 40),
                        color:
                            rate3 ? Colors.yellow.shade600 : Colors.grey.shade900,
                        onPressed: () {
                          setState(() {
                            rate1 = false;
                            rate2 = false;
                            rate3 = !rate3;
                            rate4 = false;
                            rate5 = false;
                            feedbackContent['rating'] = 3;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.sentiment_satisfied, size: 40),
                        color: rate4
                            ? Colors.lightGreen.shade500
                            : Colors.grey.shade900,
                        onPressed: () {
                          setState(() {
                            rate1 = false;
                            rate2 = false;
                            rate3 = false;
                            rate4 = !rate4;
                            rate5 = false;
                            feedbackContent['rating'] = 4;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.sentiment_very_satisfied, size: 40),
                        color:
                            rate5 ? Colors.green.shade800 : Colors.grey.shade900,
                        onPressed: () {
                          setState(() {
                            rate1 = false;
                            rate2 = false;
                            rate3 = false;
                            rate4 = false;
                            rate5 = !rate5;
                            feedbackContent['rating'] = 5;
                            print(feedbackContent['rating']);
                          });
                        }),
                  ],
                ),
                
                SizedBox(height: 20),
                Divider(
                  color: Colors.grey.shade900,
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      onChanged: (val){
                        setState(() {
                          feedbackContent['content'] = val;
                        });
                      },
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter a feedback comment";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      decoration: InputDecoration(
                        hintText: 'Comments / Suggestions',
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton.icon(
                        onPressed: () async {
                          if(feedbackContent['rating'] == 0){
                            Fluttertoast.showToast(
                                msg: "This is Center Short Toast",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                          if(_formKey.currentState.validate() && feedbackContent['rating'] != 0){
                            print(feedbackContent);
                            await _model.insertFeedback(feedbackContent);
                            Fluttertoast.showToast(
                              msg: "Thank you for your feedback!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          Navigator.pop(context);

                          }
                        },
                        icon: Icon(Icons.send),
                        label: Text('Send'),
                        color: Colors.grey.shade900,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
