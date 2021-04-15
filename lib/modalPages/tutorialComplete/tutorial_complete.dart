import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/components/profilePicture.dart';
import 'package:huna/modalPages/rate/rateReview_view.dart';
import 'package:huna/modalPages/test/bookings_pretest.dart';
import 'package:huna/modalPages/test/results/results_pretestview.dart';
import 'package:huna/modalPages/tutorialInSession/tutorialInSession.dart';
import 'package:huna/secondaryPages/viewStudentProfile.dart';
import 'package:intl/intl.dart';
import 'tutorial_complete_modal.dart';
import '../test/answertest.dart';

TutorialCompleteModal _modal = TutorialCompleteModal();

class TutorialComplete extends StatefulWidget {
  final data;
  final flag;

  const TutorialComplete({Key key, this.data, this.flag});

  @override
  _TutorialCompleteState createState() => _TutorialCompleteState();
}

class _TutorialCompleteState extends State<TutorialComplete> {

  Map<String, int> retVal;

  @override
  void initState() {
    super.initState();
    //initAwait();
    print(widget.flag.toString() + " this is flag");
  }

  @override
  Widget build(BuildContext context) {
    //var parsedDate = DateTime.parse(widget.studentData['bookingData']['date']);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Bookings()),
                  // );
                }),
            title: Text('Tutorial Complete'),
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            widget.flag == 1
                ? Tutor(tutorData: widget.data, flag: widget.flag)
                : Student(studentData: widget.data, flag: widget.flag),
            StreamBuilder(
                stream: _modal.getResults(widget.data['bookingId']),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Widget retWidget;
                  int preCorrect = 0;
                  int postCorrect = 0;
                  int total = 0;
                  if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                    retWidget = Container(height: 0, width: 0);
                  }
                  if (snapshot.hasData) {
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      print(snapshot.data.docs[i]['students_answer_pre-test']);
                      var questionSnapshot = snapshot.data.docs[i];
                      if (questionSnapshot['students_answer_pre-test'] ==
                              questionSnapshot['answer1'] &&
                          questionSnapshot['students_answer_post-test'] ==
                              questionSnapshot['answer1']) {
                        preCorrect++;
                        postCorrect++;
                      } else if (questionSnapshot['students_answer_pre-test'] ==
                          questionSnapshot['answer1']) {
                        preCorrect++;
                      } else if (questionSnapshot[
                              'students_answer_post-test'] ==
                          questionSnapshot['answer1']) {
                        postCorrect++;
                      }
                    }
                    total = snapshot.data.docs.length;
                    retWidget = Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            child: Column(
                          children: [
                            Text('$preCorrect / $total'),
                            Text('Pre-test Results')
                          ],
                        )),
                        Container(
                            child: Column(
                          children: [
                            Text('$postCorrect / $total'),
                            Text('Post-test Results')
                          ],
                        )),
                      ],
                    );
                  }
                  return retWidget;
                }),
            StreamBuilder(
              stream: _modal.getStatus(widget.data['bookingId']),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Widget retWidget;
                int postCorrect, preCorrect, total = 0;
                if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                  retWidget = Container(height: 0, width: 0);
                }
                if (snapshot.hasData) {
                  snapshot.data.docs[0]['testData']
                              ['posttest_answeredStatus'] ==
                          '1'
                      ? retWidget = Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30, top: 15),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton.icon(
                                onPressed: () {
                                  //print(widget.studentData['testData'].toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RateReviewView(
                                            flag: widget.flag,
                                            data: widget.data)),
                                  );
                                },
                                icon: Icon(Icons.assignment),
                                label: Text('Rate and Review'),
                                color: Colors
                                    .purple, // Colors.grey if not yet answered.
                                textColor: Colors.white,
                              )),
                        )
                      : retWidget = Container(height: 0, width: 0);
                }
                return retWidget;
              },
            )
          ]))),
    );
  }
}

class Student extends StatefulWidget {
  //left
  final studentData;
  final flag;
  Student({this.studentData, this.flag});
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              width: 75,
              height: 75,
              child: GestureDetector(
                child: FutureBuilder(
                  future: _modal.getPicture(
                      widget.studentData['bookingData']['tutor_userid']),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    Widget retVal;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      retVal = Container(child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      retVal = CircleAvatar(
                          child: ProfilePicture(
                        url: snapshot.data,
                        radius: 40,
                      ));
                    }
                    return retVal;
                  },
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
              '${widget.studentData['bookingData']['tutor_firstName']} ${widget.studentData['bookingData']['tutor_lastName']}',
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
            title: Text(DateFormat.yMMMEd().format(
                DateTime.parse(widget.studentData['bookingData']['date']))),
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
            title:
                Text('P ' + widget.studentData['bookingData']['rate'] + ".00"),
            dense: true,
          ),
          Center(child: SizedBox(height: 20)),

          Center(child: SizedBox(height: 20)),

          StreamBuilder(
              stream: _modal.getStatus(widget.studentData['bookingId']),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Widget retWidget;
                if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                  retWidget = Container(height: 0, width: 0);
                }
                if (snapshot.hasData) {
                  snapshot.data.docs[0]['testData']
                              ['posttest_answeredStatus'] ==
                          '0'
                      ? retWidget = SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () {
                              print(widget.studentData['testData'].toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnswerPretestPage(
                                        testData: widget.studentData, flag: 1)),
                              );
                            },
                            icon: Icon(Icons.assignment),
                            label: Text('Answer Post-test'),
                            color: Colors
                                .purple, // Colors.grey if not yet answered.
                            textColor: Colors.white,
                          ),
                        )
                      : retWidget = Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton.icon(
                                onPressed: () {
                                  print(widget.studentData['testData']
                                      .toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResultsPage(
                                            testData: widget.studentData,
                                            flag: widget.flag,
                                            stackFlag: 0)),
                                  );
                                },
                                icon: Icon(Icons.assignment),
                                label: Text('View Pre-test Results'),
                                color: Colors
                                    .blue, // Colors.grey if not yet answered.
                                textColor: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton.icon(
                                onPressed: () {
                                  print(widget.studentData['testData']
                                      .toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResultsPage(
                                            testData: widget.studentData,
                                            flag: widget.flag,
                                            stackFlag: 0)),
                                  );
                                },
                                icon: Icon(Icons.assignment),
                                label: Text('View Post-test Results'),
                                color: Colors
                                    .green, // Colors.grey if not yet answered.
                                textColor: Colors.white,
                              ),
                            )
                          ],
                        );
                }
                return retWidget;
              })
        ],
      ),
    );
  }
}

class Tutor extends StatefulWidget {
  //right
  final flag;
  final tutorData;
  Tutor({this.tutorData, this.flag});

  @override
  _TutorState createState() => _TutorState();
}

class _TutorState extends State<Tutor> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              width: 75,
              height: 75,
              child: GestureDetector(
                child: FutureBuilder(
                  future: _modal.getPicture(
                      widget.tutorData['bookingData']['student_id']),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    Widget retVal;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      retVal = Container(child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      retVal = CircleAvatar(
                          child: ProfilePicture(
                        url: snapshot.data,
                        radius: 40,
                      ));
                    }
                    return retVal;
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StudentProfilePage(studentData: widget.tutorData)),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              '${widget.tutorData['bookingData']['student_firstName']} ${widget.tutorData['bookingData']['student_lastName']}',
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
            title: Text(DateFormat.yMMMEd().format(
                DateTime.parse(widget.tutorData['bookingData']['date']))),
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
            title: Text('P ' + widget.tutorData['bookingData']['rate'] + ".00"),
            dense: true,
          ),
          Center(child: SizedBox(height: 20)),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: RaisedButton.icon(
              onPressed: () {
                print(widget.tutorData['testData'].toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultsPage(
                            testData: widget.tutorData,
                            flag: 0,
                            stackFlag: 0,
                          )),
                );
              },
              icon: Icon(Icons.assignment),
              label: Text('View Pre-test Results'),
              color: Colors.blue, // Colors.grey if not yet answered.
              textColor: Colors.white,
            ),
          ),

          StreamBuilder(
              stream: _modal.getStatus(widget.tutorData['bookingId']),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Widget retWidget;
                if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                  retWidget = Container(height: 0, width: 0);
                }
                if (snapshot.hasData) {
                  snapshot.data.docs[0]['testData']
                              ['posttest_answeredStatus'] ==
                          '1'
                      ? retWidget = SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton.icon(
                            onPressed: () {
                              print(widget.tutorData['testData'].toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultsPage(
                                        testData: widget.tutorData,
                                        flag: 1,
                                        stackFlag: 0)),
                              );
                            },
                            icon: Icon(Icons.assignment),
                            label: Text('View Post-test Results'),
                            color: Colors.green,
                            textColor: Colors.white,
                          ),
                        )
                      : retWidget = Container(
                          width: 0,
                          height: 0,
                        );
                }
                return retWidget;
              })
        ],
      ),
    );
  }
}
