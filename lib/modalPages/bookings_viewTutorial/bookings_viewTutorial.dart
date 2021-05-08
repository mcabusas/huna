import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/components/profilePicture.dart';
import 'package:huna/modalPages/test/bookings_pretest.dart';
import 'package:huna/modalPages/test/results/results_pretestview.dart';
import 'package:huna/secondaryPages/viewStudentProfile.dart';
import 'package:intl/intl.dart';
import 'bookings_viewTutorial_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../test/edit_test/edit_testview.dart';
import '../tutorialInSession/tutorialInSession.dart';

ViewTutorialModel _model = new ViewTutorialModel();

class ViewTutorialPage extends StatefulWidget {
  final data;
  final flag;
  const ViewTutorialPage({Key key, this.data, this.flag});

  @override
  _ViewTutorialState createState() => _ViewTutorialState();
}

class _ViewTutorialState extends State<ViewTutorialPage> {
  String uid, tutorid;
  SharedPreferences sp;
  Map<String, dynamic> pretestInfo;

  

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
      tutorid = sp.getString('tid');
    });
  }

  createPretest() async {
    pretestInfo = {
      'student_id': widget.data['bookingData']['student_id'],
      'tutor_uid': uid,
      'tutor_id': tutorid,
      'pretest_id': widget.data['bookingId'],
    };

    await _model.createPretest(pretestInfo).then((value) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PretestPage(pretestid: pretestInfo['pretest_id'])),
          )
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data['bookingData']);
    initAwait();
    print(widget.flag.toString() + "this is flag");
  }
  //int flag = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bookings()),
              );
            }),
        title: Text('Tutorial'),
      ),
      body: widget.flag == 1 ? Tutor(studentData: widget.data, flag: widget.flag) : Student(tutorData: widget.data, flag: widget.flag)
    );
  }
}



class Student extends StatefulWidget {
  final tutorData;
  final flag;
  Student({this.tutorData, this.flag});
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[

              
              Center(
                child: Container(
                  width: 75,
                  height: 75,
                  child: GestureDetector(
                    child: FutureBuilder(
                      future: _model.getPicture(widget.tutorData['bookingData']['tutor_userid']),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        Widget retVal;
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          retVal = Container(child: CircularProgressIndicator());
                        }
                        if(snapshot.connectionState == ConnectionState.done){
                          retVal = 
                            ClipOval(
                                  child: ProfilePicture(url: snapshot.data, width: 45, height: 45)
                                );
                        }
                        return retVal;
                      },
                    ),
                    
                    onTap: () {
                      print(widget.tutorData['bookingData']['tutor_userid']);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => StudentProfilePage(
                      //           studentData: widget.tutorDataz)),
                      // );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  '${widget.tutorData['bookingData']['tutor_firstName']} ${widget.tutorData['bookingData']['tutor_lastName']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Center(child: Text('@'+widget.tutorData['username'])),
              Center(child: SizedBox(height: 20)),
              // BOOKING DETAILS
              Center(
                child: Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.import_contacts),
                title: Text(widget.tutorData['bookingData']['topic']),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.place),
                title: Text(widget.tutorData['bookingData']['location']),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text(DateFormat.yMMMEd().format(DateTime.parse(widget.tutorData['bookingData']['date']))),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(
                    '${widget.tutorData['bookingData']['timeStart']} - ${widget.tutorData['bookingData']['timeEnd']}'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text(
                    'P ' + widget.tutorData['bookingData']['rate'] + ".00"),
                dense: true,
              ),
              Center(child: SizedBox(height: 20)),
              // BUTTONS // ONLY ONE IS ACTIVATED AT A TIME.
              // CREATE PRETEST IF ONE HASN'T BEEN MADE YET

              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultsPage(
                                      testData: widget.tutorData, flag: 0, stackFlag: 0)),
                            );
                          },
                          icon: Icon(Icons.assignment),
                          label: Text('View Pretest Answers'),
                          color:
                              Colors.purple, // Colors.grey if not yet answered.
                          textColor: Colors.white,
                        ),
                      ),
            ],
          ),
        ),
      );
  }
}

class Tutor extends StatefulWidget {
  final studentData;
  final flag;
  Tutor({this.studentData, this.flag});

  
  @override
  _TutorState createState() => _TutorState();
}

class _TutorState extends State<Tutor> {

  ViewTutorialModel _model = new ViewTutorialModel();
  String uid, tutorid;
  SharedPreferences sp;
  Map<String, dynamic> pretestInfo;

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
      tutorid = sp.getString('tid');
    });
  }

  createPretest() async {
    pretestInfo = {
      'student_id': widget.studentData['bookingData']['student_id'],
      'tutor_uid': uid,
      'tutor_id': tutorid,
      'pretest_id': widget.studentData['bookingId'],
    };

    await _model.createPretest(pretestInfo).then((value) => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PretestPage(pretestid: pretestInfo['pretest_id'])),
          )
        });
  }
  
  @override
  void initState() {
    super.initState();
    print('tutor');
    initAwait();
  }

  @override
  Widget build(BuildContext context) {
    String bookingDate = DateFormat.yMMMEd().format(DateTime.parse(widget.studentData['bookingData']['date']));
    String currentDate = DateFormat.yMMMEd().format(DateTime.parse(DateTime.now().toString()));
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[

              
              Center(
                child: Container(
                  width: 75,
                  height: 75,
                  child: GestureDetector(
                    child: FutureBuilder(
                      future: _model.getPicture(widget.studentData['bookingData']['student_id']),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        Widget retVal;
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          retVal = Container(child: CircularProgressIndicator());
                        }
                        if(snapshot.connectionState == ConnectionState.done){
                          retVal = ClipOval(
                                  child: ProfilePicture(url: snapshot.data, width: 45, height: 45)
                                );
                        }
                        return retVal;
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentProfilePage(
                                studentData: widget.studentData)),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  '${widget.studentData['bookingData']['student_firstName']} ${widget.studentData['bookingData']['student_lastName']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Center(child: Text('@'+widget.studentData['username'])),
              Center(child: SizedBox(height: 20)),
              // BOOKING DETAILS
              Center(
                child: Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.import_contacts),
                title: Text(widget.studentData['bookingData']['topic']),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.place),
                title: Text(widget.studentData['bookingData']['location']),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text(DateFormat.yMMMEd().format(DateTime.parse(widget.studentData['bookingData']['date']))),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(
                    '${widget.studentData['bookingData']['timeStart']} - ${widget.studentData['bookingData']['timeEnd']}'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text(
                    'P ' + widget.studentData['bookingData']['rate'] + ".00"),
                dense: true,
              ),
              Center(child: SizedBox(height: 20)),
              // BUTTONS // ONLY ONE IS ACTIVATED AT A TIME.
              // CREATE PRETEST IF ONE HASN'T BEEN MADE YET

              StreamBuilder(
                stream: _model.getStatus(widget.studentData['bookingId']),
                builder: (context, snapshot) {
                  Widget retWidget;
                  Color editBtnColor, beginBtn, viewBtn, sendBtn, createBtn;
                  
                  if(!snapshot.hasData || snapshot.data.docs.isEmpty){
                    retWidget = Container(height: 0, width: 0);
                  }
                  if(snapshot.hasData){

                    if(snapshot.data.docs[0]['testData']['test_id'] == snapshot.data.docs[0]['bookingId']){
                      editBtnColor = Colors.purple;
                      sendBtn = Colors.cyan;
                      createBtn = Colors.grey;
                    } else {
                      editBtnColor = Colors.grey;
                      sendBtn = Colors.grey;
                      createBtn = Colors.lightGreen;
                    }
                    

                    if(snapshot.data.docs[0]['testData']['pretest_answeredStatus']  == '1') {
                      beginBtn = Colors.green;
                      viewBtn = Colors.purple;
                    } else {
                      beginBtn = Colors.grey;
                      viewBtn = Colors.grey;
                    }

                    // if(snapshot.data.docs[0]['testData']['test_sentStatus'] == '0') {
                    //   createBtn = Colors.lightGreen;
                    // } else {
                    //   createBtn = Colors.grey;
                    // }
                    snapshot.data.docs[0]['testData']['test_sentStatus'] == '0'
                    ? retWidget = Column(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () async {
                              // Alert Dialog: Create Pretest

                              createPretest();
                            },
                            icon: Icon(Icons.add),
                            label: Text('Create Pretest Questions'),
                            color: createBtn,
                            textColor: Colors.white,
                          ),
                        ),

                        

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () {
                              if(editBtnColor == Colors.purple) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new EditPage(
                                            pretestId:
                                                widget.studentData['bookingId'],
                                          )),
                                );
                              } else if(editBtnColor == Colors.grey){
                                Fluttertoast.showToast(
                                    msg: "Please create test first before editing questions.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            },
                            icon: Icon(Icons.assignment),
                            label: Text('Edit Pretest Questions/Answers'),
                            color:editBtnColor, // Colors.grey if not yet answered.
                            textColor: Colors.white,
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () {

                              if(sendBtn == Colors.cyan) {

                                showDialog(
                                  builder: (context) => AlertDialog(
                                    title: Text("Send Pretest"),
                                    content: Text(
                                        "Are you sure you want to send the pretest?\n\nNOTE: You won't be able to change or edit the test once it's sent."),
                                    elevation: 24.0,
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(
                                                'dialog'), // Navigator.pop(context) closes the entire page.
                                        child: Text(
                                          "No",
                                          style: TextStyle(color: Colors.cyan),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          bool catcher = await _model.updateSentStatus(widget.studentData['bookingId']);
                                          if(catcher) {
                                            Fluttertoast.showToast(
                                                msg: "Test has been sent to student.",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIos: 1,
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                          }
                                            

                                          //Proceeding to Create a Pretest
                                          Navigator.of(context, rootNavigator: true)
                                              .pop('dialog');
                                        },
                                        child: Text(
                                          "Yes",
                                          style:
                                              TextStyle(color: Colors.deepPurple),
                                        ),
                                      ),
                                    ],
                                  ), context: context,
                                );

                              } else {

                                Fluttertoast.showToast(
                                    msg: "Please create pre-test.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                              // Alert Dialog: Create Pretest
                              
                            },
                            icon: Icon(Icons.send),
                            label: Text('Send Pretest'),
                            color: sendBtn,
                            textColor: Colors.white,
                          ),
                        ),
                        // IF PRETEST HAS BEEN CREATED


                        
                      ])
                    :
                    retWidget = Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () {

                              if(viewBtn == Colors.purple) {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultsPage(
                                          testData: widget.studentData, flag: 0, stackFlag: 0,)),
                                );

                              } else {

                                Fluttertoast.showToast(
                                    msg: "Student must answer pre-test before you can see his answers.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );

                              }
                              
                            },
                            icon: Icon(Icons.assignment),
                            label: Text('View Pretest Answers'),
                            color: viewBtn, // Colors.grey if not yet answered.
                            textColor: Colors.white,
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () async {

                              

                              print(bookingDate);
                              print(currentDate);

                              // if()

                              if(beginBtn == Colors.green && bookingDate == currentDate) {
                                _model.beginTutorial(widget.studentData['bookingId']).then((value) => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TutorialInSession(
                                          data: widget.studentData,
                                          flag: widget.flag
                                            )),
                                  )
                                });
                              } else if(beginBtn != Colors.green){
                                Fluttertoast.showToast(
                                    msg: "Student must answer pre-test before begining tutorial.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              } else if(bookingDate != currentDate) {

                                Fluttertoast.showToast(
                                    msg: "You can only begin the tutorial on the date you have agreed on.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );

                              }
                              
                              
                            },
                            icon: Icon(Icons.assignment_turned_in),
                            label: Text('Begin Tutorial'),
                            color: beginBtn, // Colors.grey if not yet answered.
                            textColor: Colors.white,
                          ),
                        )
                      ]
                    );
                  }
                  return retWidget;
                }
              )
            ],
          ),
        ),
      );
  }
}
