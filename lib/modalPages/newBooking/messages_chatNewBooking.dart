import 'package:fluttertoast/fluttertoast.dart';
import 'package:huna/components/profilePicture.dart';
import 'package:huna/dashboard/dashboard.dart';
import '../map.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'messages_chatNewBooking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../paytutorial/paytutorial.dart';

MessagesNewBookingModel _model = new MessagesNewBookingModel();
SharedPreferences sp;
String firstName, lastName, studentid;

class NewBooking extends StatefulWidget {
  final tutorInfo, chatRoomId;

  const NewBooking({Key key, this.tutorInfo, this.chatRoomId});

  @override
  _NewBookingState createState() => _NewBookingState();
}

class _NewBookingState extends State<NewBooking> {
  DateTime _dateTime;
  TimeOfDay _timeStart;
  TimeOfDay _timeEnd;
  String location = '';
  String formattedTimeOfStart;
  String formattedTimeOfEnd;
  Map retVal;
  bool showSpinner = false;
  bool returnValue;
  final _key = new GlobalKey<FormState>();

  Map<String, dynamic> bookingData = {
    'student_id': '',
    'student_firstName': '',
    'student_lastName': '',
    'tutor_firstName': '',
    'tutor_lastName': '',
    'tutor_userid': '',
    'tutor_id': '',
    'date': '', //_dateTime.toString(),
    'timeStart': '', //formattedTimeOfStart,
    'timeEnd': '', //formattedTimeOfEnd,
    'topic': '',
    'location': '',
    'numberOfStudents': '',
    'locationId': '',
    'booking_status': 'Pending',
    'rate': '',
    'total': ''
  };

  Map<String, dynamic> testData = {
    'test_id': '',
    'test_sentStatus': '0',
    'pretest_answeredStatus': '0',
    'posttest_answeredStatus': '0'
  };

  _location(BuildContext context) async {
    retVal = await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new MapSample()));
    updateLocation(retVal);
    
  }
  void updateLocation(var _location) {
    setState(() {
      bookingData['locationId'] = _location['placeId'];
      bookingData['location'] = _location['description'];
    });
  }

  Future initAwait() async {
    sp = await SharedPreferences.getInstance();
    print(sp.getString('firstName'));
    print(sp.getString('lastName'));
    print(sp.getString('uid'));
    setState(() {
      firstName = sp.getString('firstName');
      lastName = sp.getString('lastName');
      studentid = sp.getString('uid');
      bookingData['student_firstName'] = firstName;
      bookingData['student_lastName'] = lastName;
      bookingData['student_id'] = studentid;
      bookingData['tutor_id'] = widget.tutorInfo['tutor_id'];
      bookingData['tutor_userid'] = widget.tutorInfo['tutor_userid'];
      bookingData['tutor_lastName'] = widget.tutorInfo['lastName'];
      bookingData['tutor_firstName'] = widget.tutorInfo['firstName'];
      bookingData['rate'] = widget.tutorInfo['rate'];
    });
  }

  @override
  void initState() {
    super.initState();
    initAwait();
    //print(widget.tutorInfo);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Tutorial Booking'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Other Person
                      Column(
                        children: <Widget>[
                          Container(
                            width: 75,
                            height: 75,
                            child: FutureBuilder(
                                future: _model.getPicture(studentid),
                                builder:  (BuildContext context, AsyncSnapshot snap) {
                                  Widget picture;
                                  if (snap.connectionState ==ConnectionState.waiting) {
                                    picture = Container(child: CircularProgressIndicator());
                                  }
                                  if (snap.connectionState ==ConnectionState.done) {
                                    picture = ClipOval(
                                  child: ProfilePicture(url: snap.data, width: 45, height: 45)
                                );
                                  }

                                  return picture;
                                }),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '$firstName $lastName',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('@'),
                        ],
                      ),
                      // You
                      Column(
                        children: <Widget>[
                          Container(
                            width: 75,
                            height: 75,
                             child: 
                            FutureBuilder(
                                future: _model.getPicture(widget.tutorInfo['tutor_userid']),
                                builder:  (BuildContext context, AsyncSnapshot snap) {
                                  Widget picture;
                                  if (snap.connectionState ==ConnectionState.waiting) {
                                    picture = Container(child: CircularProgressIndicator());
                                  }
                                  if (snap.connectionState == ConnectionState.done) {
                                    picture = ClipOval(
                                  child: ProfilePicture(url: snap.data, width: 45, height: 45)
                                );
                                  }

                                  return picture;
                                }),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '${widget.tutorInfo['firstName']} ${widget.tutorInfo['lastName']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Please enter a topic";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      bookingData['topic'] = value;
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.import_contacts),
                      labelText: 'Topic',
                    ),
                  ),

                  SizedBox(height: 20),

                  RaisedButton.icon(
                    onPressed: () {
                      _location(context);
                    },
                    icon: Icon(Icons.place),
                    label: Text('Search for Location'),
                    color: Colors.blue.shade800,
                    textColor: Colors.white,
                  ),

                  Container(
                    
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(child: Text(bookingData['location']), width: 250),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            (Icons.location_on_outlined)
                          ),
                        ),
                      ],
                    )
                  ),

                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Please enter the number of students";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        bookingData['numberOfStudents'] = value;
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.people),
                      labelText: 'Number of Students',
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                  ),

                  // DATE PICKER
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Date: ',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            _dateTime == null
                                ? ''
                                : DateFormat('MMMM d, yyyy')
                                    .format(_dateTime)
                                    .toString(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: RaisedButton.icon(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2022),
                              ).then((date) {
                                setState(() {
                                  _dateTime = date;
                                  bookingData['date'] = _dateTime.toString();
                                });
                              });
                            },
                            icon: Icon(Icons.event),
                            label: Text('Date'),
                            color: Colors.grey.shade900,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TIME PICKER START
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Time Start: ',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(_timeStart == null
                              ? ''
                              : _timeStart.format(context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: RaisedButton.icon(
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((timeStart) {
                                setState(() {
                                  _timeStart = timeStart;
                                  final MaterialLocalizations localizations =
                                      MaterialLocalizations.of(context);
                                  formattedTimeOfStart =
                                      localizations.formatTimeOfDay(_timeStart);
                                  bookingData['timeStart'] =
                                      formattedTimeOfStart;
                                });
                              });
                            },
                            icon: Icon(Icons.access_time),
                            label: Text('Time'),
                            color: Colors.grey.shade900,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TIME PICKER END
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Time End: ',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                              _timeEnd == null ? '' : _timeEnd.format(context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: RaisedButton.icon(
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((timeEnd) {
                                setState(() {
                                  _timeEnd = timeEnd;
                                  final MaterialLocalizations localizations =
                                      MaterialLocalizations.of(context);
                                  formattedTimeOfEnd =
                                      localizations.formatTimeOfDay(_timeEnd);
                                  bookingData['timeEnd'] = formattedTimeOfEnd;
                                });
                              });
                            },
                            icon: Icon(Icons.access_time),
                            label: Text('Time'),
                            color: Colors.grey.shade900,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Fee
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total: ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text("P ${widget.tutorInfo['rate']}.00",
                            style: TextStyle(fontSize: 30)),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // IF STUDENT SENDS BOOKING REQUEST:
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton.icon(
                      onPressed: () async {
                        if (_key.currentState.validate()) {
                          if(bookingData['timeStart'] == '' || bookingData['timeEnd'] == '' || bookingData['date'] == ''){
                            Fluttertoast.showToast(
                                msg: "You are missing data such has a time start or didn't insert a date.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else {
                            setState(() {
                              showSpinner = true;
                              bookingData['total'] = (double.parse(bookingData['rate']) * double.parse(bookingData['numberOfStudents'])).toString();
                            });

                            try {
                              returnValue = await _model.createBooking(
                                  bookingData, testData);
                              if (returnValue == true) {
                                setState(() {
                                  showSpinner = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "Booking request sent",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                print('inserted');
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          }
                          
                        }
                      },
                      icon: Icon(Icons.assignment),
                      label: Text('Send Booking Request'),
                      color: Colors.deepPurple,
                      textColor: Colors.white,
                    ),
                  ),

                  // IF TUTOR ACCEPTS BOOKING REQUEST BUTTONS
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: <Widget>[
                  //       RaisedButton.icon(
                  //         onPressed: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => Bookings()),
                  //           );
                  //         },
                  //         icon: Icon(Icons.clear),
                  //         label: Text('Decline'),
                  //         color: Colors.red.shade800,
                  //         textColor: Colors.white,
                  //       ),
                  //       RaisedButton.icon(
                  //         onPressed: () {
                  //           print(bookingData);
                  //           //_model.createBooking(widget.tutorInfo, widget.chatRoomId);
                  //           // Navigator.push(
                  //           //   context,
                  //           //   MaterialPageRoute(builder: (context) => DashboardPage()),
                  //           // );
                  //         },
                  //         icon: Icon(Icons.check),
                  //         label: Text('Accept'),
                  //         color: Colors.lightGreen,
                  //         textColor: Colors.white,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
