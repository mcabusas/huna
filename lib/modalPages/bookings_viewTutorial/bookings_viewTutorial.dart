import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/modalPages/test/bookings_pretest.dart';
import 'package:huna/modalPages/test/results/results_pretestview.dart';
import 'package:huna/secondaryPages/viewStudentProfile.dart';
import 'package:intl/intl.dart';
import 'bookings_viewTutorial_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../test/edit_test/edit_testview.dart';
import '../tutorialInSession/tutorialInSession.dart';

class ViewTutorialPage extends StatefulWidget {
  final data;
  final flag;
  const ViewTutorialPage({Key key, this.data, this.flag});

  @override
  _ViewTutorialState createState() => _ViewTutorialState();
}

class _ViewTutorialState extends State<ViewTutorialPage> {
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
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                    ),
                    onTap: () {
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
    print('tutor');
    initAwait();
  }
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
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/tutor2.jpg'),
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

                  if(!snapshot.hasData || snapshot.data.docs.isEmpty){
                    retWidget = Container(height: 0, width: 0);
                  }
                  if(snapshot.hasData){
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
                            color: Colors.lightGreen,
                            textColor: Colors.white,
                          ),
                        ),
                        // IF PRETEST HAS BEEN CREATED

                        // VIEW PRETEST ANSWERS
                        // IF STUDENT HAS ANSWERED THE PRETEST
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new EditPage(
                                          pretestId:
                                              widget.studentData['bookingId'],
                                        )),
                              );
                            },
                            icon: Icon(Icons.assignment),
                            label: Text('Edit Pretest Questions/Answers'),
                            color:
                                Colors.purple, // Colors.grey if not yet answered.
                            textColor: Colors.white,
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () {
                              // Alert Dialog: Create Pretest
                              showDialog(
                                builder: (context) => AlertDialog(
                                  title: Text("Send Pretest"),
                                  content: Text(
                                      "Are you sure you want to send the pretest?"),
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
                                      onPressed: () {
                                        _model.updateSentStatus(
                                            widget.studentData['bookingId']);

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
                            },
                            icon: Icon(Icons.send),
                            label: Text('Send Pretest'),
                            color: Colors.cyan,
                            textColor: Colors.white,
                          ),
                        ),
                      ])
                    :
                    retWidget = Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultsPage(
                                        testData: widget.studentData, flag: 0, stackFlag: 0,)),
                              );
                            },
                            icon: Icon(Icons.assignment),
                            label: Text('View Pretest Answers'),
                            color:
                                Colors.purple, // Colors.grey if not yet answered.
                            textColor: Colors.white,
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () async {
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
                              
                            },
                            icon: Icon(Icons.assignment_turned_in),
                            label: Text('Begin Tutorial'),
                            color:
                                Colors.green, // Colors.grey if not yet answered.
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
