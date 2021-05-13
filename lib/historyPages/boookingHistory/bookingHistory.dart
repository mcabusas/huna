import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/components/profilePicture.dart';
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
    return await _modal.getStudentHistory(widget.uid);
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
              retWidget = Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                              'Total Spent: ' +
                                  snapshot.data['total'].toString(),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 24)))),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(15),
                    itemCount:
                        snapshot == null ? 0 : snapshot.data['docData'].length,
                    itemBuilder: (BuildContext context, int index) {
                      Widget card;
                      var parsedDate = DateTime.parse(
                          snapshot.data['docData'][index]['date']);
                      Color color;
                      if (snapshot.data['docData'][index]['status'] ==
                          'Finished') {
                        color = Colors.greenAccent;
                      } else if (snapshot.data['docData'][index]['status'] ==
                              'Declined' ||
                          snapshot.data['docData'][index]['status'] ==
                              'Cancelled') {
                        color = Colors.red;
                      }
                      if (snapshot.data['docData'][index]
                                  ['status'] ==
                              'Finished' ||
                          snapshot.data['docData'][index]['status'] ==
                              'Declined' ||
                          snapshot.data['docData'][index]['status'] ==
                              'Cancelled') {
                        card = Card(
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            children: <Widget>[
                              // Per Booking, PRETEST
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  leading: FutureBuilder(
                                    future: _modal.getPicture(
                                        snapshot.data['docData'][index]['uid']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      Widget retVal;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        retVal = Container(
                                            child: CircularProgressIndicator());
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        retVal = ClipOval(
                                            child: ProfilePicture(
                                                url: snapshot.data,
                                                width: 45,
                                                height: 45));
                                      }
                                      return retVal;
                                    },
                                  ),
                                  title: Text(
                                      '${snapshot.data['docData'][index]['firstName']} ${snapshot.data['docData'][index]['lastName']}'),
                                  // subtitle: Text('${jsonData[index]['username']}',
                                  //     overflow: TextOverflow.ellipsis),
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
                                      title: Text(DateFormat.yMMMEd()
                                          .format(parsedDate)),
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
                                      title: Text(
                                          '${snapshot.data['docData'][index]['rate']}.00'),
                                      dense: true,
                                    ),
                                    ListTile(
                                      leading: Text('Status',
                                          style: TextStyle(color: Colors.cyan)),
                                      title: Text(
                                          '${snapshot.data['docData'][index]['status']}',
                                          style: TextStyle(
                                              color: color, fontSize: 20)),
                                      dense: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        card = Container(width: 0, height: 0);
                      }
                      return card;
                    },
                  )
                ],
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

class TutorHistoryMode extends StatefulWidget {
  final uid;
  TutorHistoryMode({this.uid});
  @override
  _TutorHistoryModeState createState() => _TutorHistoryModeState();
}

class _TutorHistoryModeState extends State<TutorHistoryMode> {
  Widget retWidget;

  Future<Map<String, dynamic>> initAwait() async {
    return await _modal.getTutorsHistory(widget.uid);
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
              retWidget = Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          padding: EdgeInsets.all(15),
                          child: Text(
                              'Total Income: ' +
                                  snapshot.data['total'].toString(),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 24)))),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15),
                      itemCount: snapshot == null
                          ? 0
                          : snapshot.data['docData'].length,
                      itemBuilder: (BuildContext context, int index) {
                        Widget card;
                        Color color;
                        if (snapshot.data['docData'][index]['status'] ==
                            'Finished') {
                          color = Colors.green;
                        } else if (snapshot.data['docData'][index]['status'] ==
                            'Declined') {
                          color = Colors.red;
                        }
                        var parsedDate = DateTime.parse(
                            snapshot.data['docData'][index]['date']);
                        if (snapshot.data['docData'][index]['status'] ==
                                'Finished' ||
                            snapshot.data['docData'][index]['status'] ==
                                'Declined') {
                          card = Card(
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10),
                              children: <Widget>[
                                // Per Booking, PRETEST
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    leading: FutureBuilder(
                                      future: _modal.getPicture(snapshot
                                          .data['docData'][index]['uid']),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        Widget retVal;
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          retVal = Container(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          retVal = ClipOval(
                                              child: ProfilePicture(
                                                  url: snapshot.data,
                                                  width: 45,
                                                  height: 45));
                                        }
                                        return retVal;
                                      },
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
                                        title: Text(DateFormat.yMMMEd()
                                            .format(parsedDate)),
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
                                        title: Text(
                                            '${snapshot.data['docData'][index]['rate']}.00'),
                                        dense: true,
                                      ),
                                      ListTile(
                                        leading: Text('Status',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        title: Text(
                                            '${snapshot.data['docData'][index]['status']}',
                                            style: TextStyle(
                                                color: color, fontSize: 20)),
                                        dense: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          card = Container(width: 0, height: 0);
                        }
                        return card;
                      }),
                ],
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
