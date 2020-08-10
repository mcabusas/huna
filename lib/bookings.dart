import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/login.dart';
import 'package:huna/modalPages/bookings_answerPretest.dart';
import 'package:huna/modalPages/bookings_viewTutorial.dart';
import 'package:huna/historyPages/bookingHistory.dart';
import 'package:http/http.dart' as http;
import 'package:huna/modalPages/drawer.dart';
import 'package:intl/intl.dart';


var page;
var jsonData;
int _selectedIndex = 0;
final tabs = [StudentModeWidget(), TutorModeWidget()];
bool isLoading = false;



class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: tabs[_selectedIndex]
    );
  }
}

class Bookings extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  Widget bottomNavBar(){
    if(u.tutorID == null){
      return null;
    }else{
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
              if(index == 0){
                page = 0;
              }else if(index == 1){
                page = 1;
              }
            });
            print(_selectedIndex);
            print(page);
          },
        ),
      );
    }
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
                MaterialPageRoute(builder: (context) => BookingHistory()),
              );
            },
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: MainWidget(),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

class StudentModeWidget extends StatefulWidget {
  @override
  _StudentModeWidgetState createState() => _StudentModeWidgetState();
}

class _StudentModeWidgetState extends State<StudentModeWidget> {

  Future getBooking() async{
     final response = await http.get(
      Uri.encodeFull("https://hunacapstone.com/database_files/getBooking.php?id=${u.id}&page=$page"),
      headers: {
        "Accept": 'application/json',
      }
    );
    if(response.statusCode == 200){
      setState(() {
        jsonData = jsonDecode(response.body);
        isLoading = true;
      });
      print(jsonData);
    }
  }

  void initState(){
    super.initState();
    getBooking();
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading == true) {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        itemCount: jsonData == null ? 0 : jsonData.length,
        itemBuilder: (BuildContext context, int index) {
          if(jsonData == null){
            return new Container();
          }else if(/*jsonData[index]['booking_status'].toString() == 'Accepted' &&*/ jsonData != null){
            var parsedDate = DateTime.parse(jsonData[index]['xmlData']['date']);
            return new Card(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                children: <Widget>[
                  // Per Booking, PRETEST
                  ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/opentutorials.jpg'),
                    ),
                    title: Text('${jsonData[index]['user_firstName']} ${jsonData[index]['user_lastName']}'),
                    subtitle: Text('${jsonData[index]['username']}', overflow: TextOverflow.ellipsis),
                    trailing: RaisedButton.icon(
                      onPressed: () {
                        // Proceeds to Pretest Directly. Made by Tutor
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnswerPretest()),
                        );
                      },
                      icon: Icon(Icons.assignment_late),
                      label: Text('Pretest'),
                      color: Colors.purple,
                      textColor: Colors.white,
                    ),
                    children: <Widget>[
                      // Expanded Contents
                      ListTile(
                        leading: Icon(Icons.import_contacts),
                        title: Text('${jsonData[index]['xmlData']['topic']}'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.place),
                        title: Text('${jsonData[index]['xmlData']['location']}'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.event),
                        title: Text(DateFormat.yMMMEd().format(parsedDate)),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text('${jsonData[index]['xmlData']['timestart']} - ${jsonData[index]['xmlData']['timeend']}'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('P ${jsonData[index]['rate']}.00'),
                        dense: true,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: RaisedButton.icon(
                            onPressed: () {},
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
            );
            }
          },
        );
    }else{
      return Center(child:CircularProgressIndicator());
    }
        // FOR STUDENT MODE
      /*Center(
      child: ListView(
        children: <Widget>[
          // PER BOOKING
          
          Divider(),

          // PER BOOKING
          /*Container(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              children: <Widget>[
                // Per Booking, PRETEST
                ExpansionTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/tutor.jpg'),
                  ),
                  title: Text('Jane Doe'),
                  subtitle: Text('@betatutor', overflow: TextOverflow.ellipsis),
                  trailing: RaisedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnTheDay()),
                      );
                    },
                    icon: Icon(Icons.assignment_turned_in),
                    label: Text('Answered'),
                    color: Colors.grey,
                    textColor: Colors.white,
                  ),
                  children: <Widget>[
                    // Expanded Contents
                    ListTile(
                      leading: Icon(Icons.import_contacts),
                      title: Text('Mobile Development'),
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(Icons.place),
                      title: Text('Talamban Campus, USC'),
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(Icons.event),
                      title: Text('February 18, 2020'),
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('10:30 AM - 12:00 PM'),
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text('P 500.00'),
                      dense: true,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: RaisedButton.icon(
                          onPressed: () {},
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
          ),*/
          Divider(),
        ],
      ),
    );*/
  }
}

class TutorModeWidget extends StatefulWidget {
  @override
  _TutorModeWidgetState createState() => _TutorModeWidgetState();
}

class _TutorModeWidgetState extends State<TutorModeWidget> {

  Future getBooking() async{
     final response = await http.get(
      Uri.encodeFull("https://hunacapstone.com/database_files/getBooking.php?id=${u.tutorID}&page=$page"),
      headers: {
        "Accept": 'application/json',
      }
    );
    if(response.statusCode == 200){
      setState(() {
        jsonData = jsonDecode(response.body);
        isLoading = true;
      });
      print(jsonData);
    }
  }

  void initState(){
    super.initState();
    getBooking();
  }
  @override
  Widget build(BuildContext context) {

    if(isLoading == true) {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        itemCount: jsonData == null ? 0 : jsonData.length,
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
          if(jsonData == null){
            return new Container();
          }else if(/*jsonData[index]['booking_status'].toString() == 'Accepted' &&*/ jsonData != null){
            var parsedDate = DateTime.parse(jsonData[index]['xmlData']['date']);
            return new Card(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                children: <Widget>[
                  // Per Booking, PRETEST
                  ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/opentutorials.jpg'),
                    ),
                    title: Text('${jsonData[index]['user_firstName']} ${jsonData[index]['user_lastName']}'),
                    subtitle: Text('${jsonData[index]['username']}', overflow: TextOverflow.ellipsis),
                    trailing: RaisedButton.icon(
                    onPressed: () {
                      // TO PRETEST DETAILS
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewTutorialPage(studentData: jsonData[index])),
                      );
                    },
                    icon: Icon(Icons.assignment),
                    label: Text('Pretest'),
                    color: Colors.cyan,
                    textColor: Colors.white,
                  ),
                    children: <Widget>[
                      // Expanded Contents
                      ListTile(
                        leading: Icon(Icons.import_contacts),
                        title: Text('${jsonData[index]['xmlData']['topic']}'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.place),
                        title: Text('${jsonData[index]['xmlData']['location']}'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.event),
                        title: Text(DateFormat.yMMMEd().format(parsedDate)),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text('${jsonData[index]['xmlData']['timestart']} - ${jsonData[index]['xmlData']['timeend']}'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('P ${jsonData[index]['rate']}.00'),
                        dense: true,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: RaisedButton.icon(
                            onPressed: () {},
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
            );
            }
          }
      );
    }else{
      return new Center(child:CircularProgressIndicator());
    }
  }
}
