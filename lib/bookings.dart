import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/login.dart';
import 'package:huna/modalPages/bookings_viewTutorial.dart';
import 'package:huna/historyPages/bookingHistory.dart';
import 'package:http/http.dart' as http;
import 'package:huna/modalPages/drawer.dart';
import 'package:intl/intl.dart';
import 'package:huna/components/buttons.dart' as component;

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
                MaterialPageRoute(builder: (context) => BookingHistoryPage(tutorID: u.tutorID)),
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
    }
    print(jsonData);
  }


  void initState(){
    super.initState();
    getBooking();
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading == true) {
      if(jsonData == null){
        return new Container(
          child: Center(
            child: Text('You have no new bookings!')
          )
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        itemCount: jsonData == null ? 0 : jsonData.length,
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
          if(/*jsonData[index]['booking_status'].toString() == 'Accepted' &&*/ jsonData != null){
            print('not empty');
            //var parsedDate = DateTime.parse(jsonData[index]['date']);
              /*return new Card(
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
                        /*ListTile(
                          leading: Icon(Icons.event),
                          title: Text(DateFormat.yMMMEd().format(parsedDate)),
                          dense: true,
                        ),*/
                        ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text('${jsonData[index]['xmlData']['timestate']} - ${jsonData[index]['xmlData']['timeend']}'),
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
              );*/
            }
          },
        );
    }else{
      return Center(child:CircularProgressIndicator());
    }
  }
}



class TutorModeWidget extends StatefulWidget {
  @override
  _TutorModeWidgetState createState() => _TutorModeWidgetState();
}

class _TutorModeWidgetState extends State<TutorModeWidget> {
  
  bool check = false;


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
    }
  }

  void initState(){
    super.initState();
    getBooking();
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading == true) {
      if(jsonData == null){
        return new Container(
          child: Center(
            child: Text('You have no new bookings! Tutor mode')
          )
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        itemCount: jsonData == null ? 0 : jsonData.length,
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
           if(/*jsonData[index]['booking_status'].toString() == 'Accepted' &&*/ jsonData != null){
            var parsedDate = DateTime.parse(jsonData[index]['xmlData']['date']);
             component.pretestBtn = new component.TrailingButton(
              buttonColor: Colors.blue.shade800, 
              buttonTitle: 'Pretest', 
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), 
              icon: Icon(Icons.assignment), 
              visible: check, 
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewTutorialPage(studentData: jsonData[index])),
                );
              }
            );
            return new Card(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                children: <Widget>[
                  // Per Booking, PRETEST
                  ExpansionTile(
                    initiallyExpanded: true,
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/opentutorials.jpg'),
                    ),
                    title: Text('${jsonData[index]['user_firstName']} ${jsonData[index]['user_lastName']}'),
                    subtitle: Text('${jsonData[index]['username']}', overflow: TextOverflow.ellipsis),
                    trailing: component.pretestBtn,
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
                      Row(
                        children: <Widget>[
                          component.acceptBtn = new component.TrailingButton(
                            buttonColor: Colors.green,
                            buttonTitle: 'Accept Booking', 
                            icon: Icon(Icons.assignment), 
                            onPressed: (){
                              setState(() {
                                check = !check;
                                print(component.pretestBtn.visible.toString());
                                component.pretestBtn.visible = check;
                                print(component.pretestBtn.visible.toString());
                                component.acceptBtn.visible = !check;
                              });
                            }, 
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10), 
                            visible: !check,
                          ),
                          component.cancelBtn = new component.TrailingButton(
                            onPressed: (){}, 
                            buttonColor: Colors.red.shade800, 
                            buttonTitle: 'Cancel Booking', 
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 10), 
                            icon: Icon(Icons.cancel), 
                            visible: true,
                          )
                        ],
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
