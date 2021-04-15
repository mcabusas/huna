import 'package:flutter/material.dart';
import 'package:huna/components/profilePicture.dart';
import 'package:huna/historyPages/boookingHistory/bookingHistory.dart';
import 'package:huna/modalPages/test/answertest.dart';
import 'package:huna/modalPages/bookings_viewTutorial/bookings_viewTutorial.dart';
import 'package:huna/drawer/drawer.dart';
import 'package:intl/intl.dart';
import 'package:huna/components/buttons.dart' as component;
import 'bookings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modalPages/tutorialInSession/tutorialInSession.dart';
import '../modalPages/tutorialComplete/tutorial_complete.dart';

var jsonData;
BookingsModel _model = new BookingsModel();
enum WidgetMaker { student, tutor }
int _selectedIndex = 0;
String prefId = '', tutorId = '';
SharedPreferences sp;
bool retVal = false;

class Bookings extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  WidgetMaker selectedWidget = WidgetMaker.student;

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      prefId = sp.getString('uid');
      tutorId = sp.getString('tid');
    });
  }

  Widget getScreen() {
    switch (selectedWidget) {
      case WidgetMaker.student:
        return StudentModeWidget(uid: prefId);

      case WidgetMaker.tutor:
        return TutorModeWidget(uid: prefId);
    }
    return getScreen();
  }

  @override
  void initState() {
    super.initState();
    initAwait();
    _selectedIndex = 0;
  }

  Widget bottomNavBar() {
    if (tutorId == '') {
      return null;
    }
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4,
      clipBehavior: Clip.antiAlias,
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Student'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            title: Text('Tutor'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              setState(() {
                selectedWidget = WidgetMaker.student;
              });
            } else if (index == 1) {
              setState(() {
                selectedWidget = WidgetMaker.tutor;
              });
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingHistoryPage()),
              );
            },
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: getScreen(),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

class StudentModeWidget extends StatefulWidget {
  final uid;
  StudentModeWidget({this.uid});

  @override
  _StudentModeWidgetState createState() => _StudentModeWidgetState();
}

class _StudentModeWidgetState extends State<StudentModeWidget> {
  // Future<List<Map<String, dynamic>>> initAwait() async {
  //   return await _model.getStudentBookings(widget.uid);
  // }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _model.getStudentBookings(widget.uid),
        builder: (context, snapshot) {
          Widget retWidget;

          if(!snapshot.hasData || snapshot.data.docs.isEmpty){
            retWidget = Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
               // padding: EdgeInsets.all(15.0),
                        height: 100,
                        width: 250,
                        child: Center(
                          child: Text('You have no new bookings'),
                        )),
            );
          }else if (snapshot.hasData) {
            
            retWidget = ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                //return new  Text(snapshot.data.docs[index]['bookingData']['student_firstName'].toString());
                //var booking = snapshot.data.docs[index]['bookingData'];

                if (snapshot.data.docs[index]['bookingData']
                        ['booking_status'] ==
                    'Finished' && snapshot.data.docs[index]['testData']['posttest_answeredStatus'] == 1) {
                  return Center(
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15.0),
                                  height: 100,
                                  width: 250,
                                  child: Center(
                                    child: Text('You have no new bookings'),
                                  )),
                      ),
                  );
                } else {
                  print(snapshot.data);
                  var parsedDate = DateTime.parse(
                      snapshot.data.docs[index]['bookingData']['date']);
                  return new Card(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      children: <Widget>[
                        // Per Booking, PRETEST
                        ExpansionTile(
                          leading: FutureBuilder(
                            future: _model.getPicture(snapshot.data.docs[index]['bookingData']['tutor_userid']),
                            builder: (BuildContext context, AsyncSnapshot snapshot){
                              Widget retVal;
                              if(snapshot.connectionState == ConnectionState.waiting) {
                                retVal = Container(child: CircularProgressIndicator());
                              }
                              if(snapshot.connectionState == ConnectionState.done){
                                retVal = CircleAvatar(
                                  child: ProfilePicture(url: snapshot.data, radius: 40,)
                                );
                              }
                              return retVal;
                            },
                          ),
                          title: Text(
                              '${snapshot.data.docs[index]['bookingData']['tutor_firstName']} ${snapshot.data.docs[index]['bookingData']['tutor_lastName']}'),
                          //subtitle: Text('${jsonData[index]['username']}', overflow: TextOverflow.ellipsis),
                          trailing: snapshot.data.docs[index]['testData']
                                      ['test_id'] ==
                                  ''
                              ? Container(height: 0, width: 0)
                              : snapshot.data.docs[index]['testData']
                                              ['test_sentStatus'] ==
                                          '1' &&
                                      snapshot.data.docs[index]['testData']
                                              ['pretest_answeredStatus'] ==
                                          '0'
                                  ? RaisedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AnswerPretestPage(
                                                      testData: snapshot
                                                          .data.docs[index],
                                                      flag: 0)),
                                        );
                                      },
                                      icon: Icon(Icons.assignment_late),
                                      label: Text('Pretest'),
                                      color: Colors.purple,
                                      textColor: Colors.white,
                                    )
                                  : Container(height: 0, width: 0),
                          children: <Widget>[
                            // Expanded Contents
                            ListTile(
                              leading: Icon(Icons.import_contacts),
                              title: Text(
                                  '${snapshot.data.docs[index]['bookingData']['topic']}'),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.place),
                              title: Text(
                                  '${snapshot.data.docs[index]['bookingData']['location']}'),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.event),
                              title:
                                  Text(DateFormat.yMMMEd().format(parsedDate)),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text(
                                  '${snapshot.data.docs[index]['bookingData']['timeStart']} - ${snapshot.data.docs[index]['bookingData']['timeEnd']}'),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text(
                                  'P ${snapshot.data.docs[index]['bookingData']['rate']}.00'),
                              dense: true,
                            ),

                            Row(
                              children: [
                                snapshot.data.docs[index]['testData']['pretest_answeredStatus'] =='1' &&(snapshot.data.docs[index]['bookingData']['booking_status'] == 'Accepted' ||
                                            snapshot.data.docs[index]
                                                        ['bookingData']
                                                    ['booking_status'] ==
                                                'Ongoing' ||
                                            (snapshot.data.docs[index]['bookingData']['booking_status'] =='Finished' && snapshot.data.docs[index]['testData']['posttest_answeredStatus'] == '0')
                                            )
                                    ? Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 10),
                                          child: RaisedButton.icon(
                                            onPressed: () {
                                              if (snapshot.data.docs[index]
                                                          ['bookingData']
                                                      ['booking_status'] ==
                                                  'Accepted') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewTutorialPage(
                                                              data: snapshot
                                                                  .data
                                                                  .docs[index],
                                                              flag: 0)),
                                                );
                                              } else if (snapshot
                                                              .data.docs[index]
                                                          ['bookingData']
                                                      ['booking_status'] ==
                                                  'Ongoing') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TutorialInSession(
                                                              data: snapshot
                                                                      .data
                                                                      .docs[
                                                                  index],
                                                              flag: 0
                                                              )),
                                                );
                                              } else if(snapshot.data.docs[index]['bookingData']['booking_status'] == 'Finished' && snapshot.data.docs[index]['testData']['posttest_answeredStatus'] == '0'){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TutorialComplete(
                                                            data: snapshot.data
                                                                .docs[index],
                                                            flag: 0),
                                                  ),
                                                );
                                              }

                                              //setStatusBooking(jsonData[index]['booking_id'], 0);
                                            },
                                            icon: Icon(Icons.assignment),
                                            label: Text('Tutorial'),
                                            color: Colors.green.shade800,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container(height: 0, width: 0),
                                SizedBox(width: 20),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: RaisedButton.icon(
                                      onPressed: () {
                                        //setStatusBooking(jsonData[index]['booking_id'], 0);
                                      },
                                      icon: Icon(Icons.cancel),
                                      label: Text('Cancel Booking'),
                                      color: Colors.red.shade800,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            retWidget = Center(child: CircularProgressIndicator());
          }

          return retWidget;
        });
  }
}

class TutorModeWidget extends StatefulWidget {
  final uid;
  TutorModeWidget({this.uid});
  @override
  _TutorModeWidgetState createState() => _TutorModeWidgetState();
}

class _TutorModeWidgetState extends State<TutorModeWidget> {
  bool check;
  Stream retVal;

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _model.getTutorBookings(widget.uid),
        builder: (context, snapshot) {
          Widget retWidget;

          if(!snapshot.hasData || snapshot.data.docs.isEmpty){
            print('empty');
            retWidget = Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15.0),
                        height: 100,
                        width: 250,
                        child: Center(
                          child: Text('You have no new bookings'),
                        )),
            );
          }else if (snapshot.hasData) {
            print('there is data');
            retWidget = ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                //return new  Text(snapshot.data.docs[index]['bookingData']['student_firstName'].toString());
                //var booking = snapshot.data.docs[index]['bookingData'];

                if (snapshot.data.docs[index]['bookingData']
                        ['booking_status'] ==
                    'Finished') {
                  return Container(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: Text('you have no new bookings'),
                      ));
                } else {
                  var parsedDate = DateTime.parse(
                      snapshot.data.docs[index]['bookingData']['date']);
                  if (snapshot.data.docs[index]['bookingData']
                          ['booking_status'] ==
                      'Pending') {
                    check = true;
                  } else if (snapshot.data.docs[index]['bookingData']
                              ['booking_status'] ==
                          'Finished' ||
                      snapshot.data.docs[index]['bookingData']
                              ['booking_status'] ==
                          'Accepted' ||
                      snapshot.data.docs[index]['bookingData']
                              ['booking_status'] ==
                          'Ongoing') {
                    check = false;
                  }

                  component.pretestBtn = new component.TrailingButton(
                      buttonColor: Colors.blue.shade800,
                      buttonTitle: 'Pretest',
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      icon: Icon(Icons.assignment),
                      visible: !check,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewTutorialPage(
                                  data: snapshot.data.docs[index], flag: 1)),
                        );
                      });

                  return new Card(
                      child: ListView(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    children: [
                      ExpansionTile(
                        leading: FutureBuilder(
                        future: _model.getPicture(snapshot.data.docs[index]['bookingData']['student_id']),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          Widget retVal;
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            retVal = Container(child: CircularProgressIndicator());
                          }
                          if(snapshot.connectionState == ConnectionState.done){
                            retVal = CircleAvatar(
                              child: ProfilePicture(url: snapshot.data, radius: 40,)
                            );
                          }
                          return retVal;
                        },
                      ),
                        title: Text(
                            '${snapshot.data.docs[index]['bookingData']['student_firstName']} ${snapshot.data.docs[index]['bookingData']['student_lastName']}'),
                        // subtitle: Text(booking['username'], overflow: TextOverflow.ellipsis),
                        trailing: component.pretestBtn,
                        children: [
                          ListTile(
                              leading: Icon(Icons.import_contacts),
                              title: Text(snapshot.data.docs[index]
                                  ['bookingData']['topic']),
                              dense: true),
                          ListTile(
                              leading: Icon(Icons.place),
                              title: Text(snapshot.data.docs[index]
                                  ['bookingData']['location']),
                              dense: true),
                          ListTile(
                            leading: Icon(Icons.event),
                            title: Text(DateFormat.yMMMEd().format(parsedDate)),
                            dense: true,
                          ),
                          ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text(
                                  '${snapshot.data.docs[index]['bookingData']['timeStart']} - ${snapshot.data.docs[index]['bookingData']['timeEnd']}'),
                              dense: true),
                          ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text(
                                  'P ${snapshot.data.docs[index]['bookingData']['rate']}.00'),
                              dense: true)
                        ],
                      ),
                      Row(
                        children: [
                          component.acceptBtn = new component.TrailingButton(
                            buttonColor: Colors.green,
                            buttonTitle: 'Accept Booking',
                            icon: Icon(Icons.assignment),
                            onPressed: () {
                              print(snapshot.data.docs[index]['bookingId']);
                              _model.updateBookingStatus(
                                  snapshot.data.docs[index]['bookingId'], 1);
                            },
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            visible: check,
                          ),
                          component.cancelBtn = new component.TrailingButton(
                            onPressed: () {
                              print(snapshot.data.docs[index]['bookingId']);
                              //print(booking.id.runtimeType);
                              //_model.updateBookingStatus(snapshot.data.docs[index]['bookingId'], 0);
                            },
                            buttonColor: Colors.red.shade800,
                            buttonTitle: 'Cancel Booking',
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 10),
                            icon: Icon(Icons.cancel),
                            visible: true,
                          )
                        ],
                      )
                    ],
                  ));
                }
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            print('loading...');
            retWidget = Center(child: CircularProgressIndicator());
          }
          return retWidget;
        });
  }
}
