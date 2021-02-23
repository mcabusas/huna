import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/modalPages/test/bookings_pretest.dart';
import 'package:huna/modalPages/test/results/results_pretestview.dart';
import 'package:huna/modalPages/tutorialInSession/tutorialInSession.dart';
import 'package:huna/secondaryPages/viewStudentProfile.dart';
import 'package:intl/intl.dart';
import 'tutorial_complete_modal.dart';
import '../test/answertest.dart';

class TutorialComplete extends StatefulWidget {
  final data;
  final flag;

  const TutorialComplete({Key key, this.data, this.flag});

  @override
  _TutorialCompleteState createState() => _TutorialCompleteState();
}

class _TutorialCompleteState extends State<TutorialComplete> {
  //ViewTutorialModel _model = new ViewTutorialModel();
  TutorialCompleteModal _modal = TutorialCompleteModal();

  Map<String, int> retVal;
  int preCorrect, postCorrect, total;

  var ret;

  Future<void> initAwait() async {
    retVal = await _modal.getPretestResult(widget.data['testData']['test_id']);
    print(retVal);
    setState(() {
      preCorrect = retVal['pre-correct'];
      postCorrect = retVal['post-correct'];
      total = retVal['total'];
    });
  }

  @override
  void initState() {
    super.initState();
    initAwait();
  }

  @override
  Widget build(BuildContext context) {
    //var parsedDate = DateTime.parse(widget.studentData['bookingData']['date']);
    return Scaffold(
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
          widget.flag == 0
              ? Student(tutorData: widget.data)
              : Tutor(
                  studentData: widget.data,
                ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  child: Column(
                children: [
                  Text('${preCorrect} / ${total}'),
                  Text('Pre-test Results')
                ],
              )),
              Container(
                  child: Column(
                children: [
                  Text('${postCorrect} / ${total}'),
                  Text('Post-test Results')
                ],
              )),
            ],
          ),
        ])));
  }
}

class Student extends StatefulWidget {
  final tutorData;
  Student({this.tutorData});
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
          // BUTTONS // ONLY ONE IS ACTIVATED AT A TIME.
          // CREATE PRETEST IF ONE HASN'T BEEN MADE YET
        ],
      ),
    );
  }
}

class Tutor extends StatefulWidget {
  final studentData;
  Tutor({this.studentData});

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

          widget.studentData['testData']['posttest_answeredStatus'] == '0'
              ? SizedBox(
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
                    color: Colors.purple, // Colors.grey if not yet answered.
                    textColor: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton.icon(
                        onPressed: () {
                          print(widget.studentData['testData'].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultsPage(
                                    testData: widget.studentData, flag: 0)),
                          );
                        },
                        icon: Icon(Icons.assignment),
                        label: Text('View Pre-test Results'),
                        color:
                            Colors.blue, // Colors.grey if not yet answered.
                        textColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton.icon(
                        onPressed: () {
                          print(widget.studentData['testData'].toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultsPage(
                                    testData: widget.studentData, flag: 1)),
                          );
                        },
                        icon: Icon(Icons.assignment),
                        label: Text('View Post-test Results'),
                        color:
                            Colors.green, // Colors.grey if not yet answered.
                        textColor: Colors.white,
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}
