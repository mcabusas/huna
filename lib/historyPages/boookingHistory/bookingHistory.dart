import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookingHistory_modal.dart';

var page;
var jsonData;
int _selectedIndex = 0;
enum WidgetMaker { student, tutor }
final tabs = [StudentHistoryMode(), TutorHistoryMode()];
HistoryModal _modal = new HistoryModal();

class BookingHistoryPage extends StatefulWidget {
  final tutorID;

  const BookingHistoryPage({this.tutorID});

  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistoryPage> {
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
        return StudentHistoryMode(uid: prefId);

      case WidgetMaker.tutor:
        return TutorHistoryMode(uid: prefId);
    }
  }

  @override
  void initState() {
    super.initState();
    initAwait();
    _selectedIndex = 0;
  }

  Widget bottomNavBar() {
    if (tutorId == null) {
      return null;
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Booking History'),
      ),
      body: SafeArea(child: getScreen()),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

class StudentHistoryMode extends StatefulWidget {
  final uid;

  StudentHistoryMode({this.uid});
  @override
  _StudentHistoryModeState createState() => _StudentHistoryModeState();
}

class _StudentHistoryModeState extends State<StudentHistoryMode> {
  Widget retWidget;

  Future<Map<String, dynamic>> initAwait() async {
    return await _modal.getHistory(widget.uid, 0);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initAwait(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data['docData'].length == 0) {
              retWidget = Container(width: 0, height: 0);
            }
            if (snapshot.data['docData'].length > 0) {
              retWidget = Text(snapshot.data['docData'][0]['firstName']);
              
              // ListView.builder(
              //   shrinkWrap: true,
              //   padding: EdgeInsets.all(15),
              //   itemCount: snapshot == null ? 0 : snapshot.data.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     var parsedDate = DateTime.parse(jsonData[index]['date']);
              //     return new Card(
              //       child: ListView(
              //         shrinkWrap: true,
              //         padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              //         children: <Widget>[
              //           // Per Booking, PRETEST
              //           ExpansionTile(
              //             leading: CircleAvatar(
              //               backgroundImage:
              //                   AssetImage('assets/images/tutor2.jpg'),
              //             ),
              //             title: Text(
              //                 '${jsonData[index]['user_firstName']} ${jsonData[index]['user_lastName']}'),
              //             subtitle: Text('${jsonData[index]['username']}',
              //                 overflow: TextOverflow.ellipsis),
              //             children: <Widget>[
              //               // Expanded Contents
              //               ListTile(
              //                 leading: Icon(Icons.import_contacts),
              //                 title: Text(
              //                     '${jsonData[index]['xmlData']['topic']}'),
              //                 dense: true,
              //               ),
              //               ListTile(
              //                 leading: Icon(Icons.place),
              //                 title: Text(
              //                     '${jsonData[index]['xmlData']['location']}'),
              //                 dense: true,
              //               ),
              //               ListTile(
              //                 leading: Icon(Icons.event),
              //                 title:
              //                     Text(DateFormat.yMMMEd().format(parsedDate)),
              //                 dense: true,
              //               ),
              //               ListTile(
              //                 leading: Icon(Icons.access_time),
              //                 title: Text(
              //                     '${jsonData[index]['xmlData']['timestart']} ${jsonData[index]['xmlData']['timeend']}'),
              //                 dense: true,
              //               ),
              //               ListTile(
              //                 leading: Icon(Icons.attach_money),
              //                 title: Text('${jsonData[index]['rate']}.00'),
              //                 dense: true,
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            retWidget =
                Container(child: Center(child: CircularProgressIndicator()));
          }

          return retWidget;
        });
  }
}

class TutorHistoryMode extends StatefulWidget {
  final uid;
  TutorHistoryMode({this.uid});
  @override
  _TutorHistoryModeState createState() => _TutorHistoryModeState();
}

class _TutorHistoryModeState extends State<TutorHistoryMode> {
  Widget retWidget;

  Future<Map<String, dynamic>> initAwait() async {
    return await _modal.getHistory(widget.uid, 1);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initAwait(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data['docData'].length.toString());
            if (snapshot.data['docData'].length == 0) {
              retWidget = Container(width: 0, height: 0);
            }
            if (snapshot.data['docData'].length > 0) {
              retWidget = 
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(15),
                itemCount: snapshot == null ? 0 : snapshot.data['docData'].length,
                itemBuilder: (BuildContext context, int index) {
                  var parsedDate = DateTime.parse(snapshot.data['docData'][index]['date']);
                  return new Card(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      children: <Widget>[
                        // Per Booking, PRETEST
                        ExpansionTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/tutor2.jpg'),
                          ),
                          title: Text(
                              '${snapshot.data['docData'][index]['firstName']} ${snapshot.data['docData'][index]['lastName']}'),
                          
                          children: <Widget>[
                            // Expanded Contents
                            ListTile(
                              leading: Icon(Icons.import_contacts),
                              title: Text(
                                  '${snapshot.data['docData'][index]['topic']}'),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.place),
                              title: Text(
                                  '${snapshot.data['docData'][index]['location']}'),
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
                                  '${snapshot.data['docData'][index]['timeStart']} ${snapshot.data['docData'][index]['timeEnd']}'),
                              dense: true,
                            ),
                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title: Text('${snapshot.data['docData'][index]['rate']}.00'),
                              dense: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            retWidget =
                Container(child: Center(child: CircularProgressIndicator()));
          }

          return retWidget;
        });
  }
}