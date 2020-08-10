import 'package:flutter/material.dart';
import 'package:huna/bookings.dart';
import 'package:huna/modalPages/bookings_pretest.dart';
import 'package:huna/secondaryPages/viewStudentProfile.dart';
import 'package:intl/intl.dart';


class ViewTutorialPage extends StatefulWidget {
  final studentData;

  const ViewTutorialPage({Key key, this.studentData});
  
  @override
  _ViewTutorialState createState() => _ViewTutorialState();
}

class _ViewTutorialState extends State<ViewTutorialPage> {

  String questions;
  TextEditingController numOfQuestions = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    var parsedDate = DateTime.parse(widget.studentData['xmlData']['date']);
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
      body: SingleChildScrollView(
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
                        MaterialPageRoute(builder: (context) => StudentProfilePage(studentData: widget.studentData)),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  '${widget.studentData['user_firstName']} ${widget.studentData['user_lastName']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Center(child: Text('@'+widget.studentData['username'])),
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
                title: Text(widget.studentData['xmlData']['topic']),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.place),
                title: Text(widget.studentData['xmlData']['location']),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text(DateFormat.yMMMEd().format(parsedDate)),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('${widget.studentData['xmlData']['timestart']} - ${widget.studentData['xmlData']['timeend']}'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('P ' + widget.studentData['rate'] + ".00"),
                dense: true,
              ),
              Center(child: SizedBox(height: 20)),
              // BUTTONS // ONLY ONE IS ACTIVATED AT A TIME.
              // CREATE PRETEST IF ONE HASN'T BEEN MADE YET
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton.icon(
                  onPressed: () {
                    // Alert Dialog: Create Pretest
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("Create Pretest"),
                        content: TextField(
                          controller: numOfQuestions,
                          decoration: InputDecoration(
                            hintText: 'Number of Questions',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        elevation: 24.0,
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true).pop(
                                    'dialog'), // Navigator.pop(context) closes the entire page.
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.cyan),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                questions = numOfQuestions.text;
                              });
                              print("continue " + questions);
                              // Proceeding to Create a Pretest
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PretestPage(totalQuestions: questions)),
                              );
                            },
                            child: Text(
                              "Continue",
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Create Pretest'),
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                ),
              ),
              // IF PRETEST HAS BEEN CREATED
              // SEND PRETEST
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton.icon(
                  onPressed: () {
                    // Alert Dialog: Create Pretest
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("Send Pretest"),
                        content:
                            Text("Are you sure you want to send the pretest?"),
                        elevation: 24.0,
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true).pop(
                                    'dialog'), // Navigator.pop(context) closes the entire page.
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.cyan),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              // Proceeding to Create a Pretest
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.send),
                  label: Text('Send Pretest'),
                  color: Colors.cyan,
                  textColor: Colors.white,
                ),
              ),
              // VIEW PRETEST ANSWERS
              // IF STUDENT HAS ANSWERED THE PRETEST
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.assignment),
                  label: Text('View Pretest Answers'),
                  color: Colors.purple, // Colors.grey if not yet answered.
                  textColor: Colors.white,
                ),
              ),
               SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.assignment),
                  label: Text('View Pretest Answers'),
                  color: Colors.purple, // Colors.grey if not yet answered.
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
