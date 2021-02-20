import 'package:flutter/material.dart';
import 'package:huna/modalPages/test/answertest.dart';
import 'package:huna/modalPages/bookings_viewTutorial/bookings_viewTutorial.dart';
import 'package:huna/drawer/drawer.dart';
import 'package:intl/intl.dart';
import 'package:huna/components/buttons.dart' as component;
import 'bookings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modalPages/test/results/results_pretestview.dart';


var jsonData;
BookingsModel _model = new BookingsModel();
enum WidgetMaker { student, tutor }
int _selectedIndex = 0;
String prefId, tutorId;
SharedPreferences sp; 
bool retVal;


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

  Widget getScreen(){
    switch(selectedWidget){
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

  Widget bottomNavBar(){
    if(tutorId == ''){
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
              if(index == 0){
                setState(() {
                   selectedWidget = WidgetMaker.student;
                 });
              }else if(index == 1){
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => BookingHistoryPage(tutorID: u.tutorID)),
              // );
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
  


  void initState(){
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
          stream: _model.getStudentBookings(widget.uid),
          builder: (context, snapshot){
            if(snapshot.data == null){
              return Center(child:CircularProgressIndicator());
            }
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
               //return new  Text(snapshot.data.docs[index]['bookingData']['student_firstName'].toString());
                //var booking = snapshot.data.docs[index]['bookingData'];
                var parsedDate = DateTime.parse(snapshot.data.docs[index]['bookingData']['date']);
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
                            title: Text('${snapshot.data.docs[index]['bookingData']['tutor_firstName']} ${snapshot.data.docs[index]['bookingData']['tutor_lastName']}'),
                            //subtitle: Text('${jsonData[index]['username']}', overflow: TextOverflow.ellipsis),
                            trailing: 
                            snapshot.data.docs[index]['pretestData']['pretest_id'] == ''  ?
                          
                              Container(height: 0, width: 0) : 
                              
                              snapshot.data.docs[index]['pretestData']['pretest_sentStatus'] == '1' && snapshot.data.docs[index]['pretestData']['pretest_answeredStatus'] == '0' ?
                              
                              RaisedButton.icon(
                                onPressed: () {
                                  
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AnswerPretestPage(testId: snapshot.data.docs[index]['bookingId'])),
                                    );
                                  
                                },
                                icon: Icon(Icons.assignment_late),
                                label: Text('Pretest'),
                                color: Colors.purple,
                                textColor: Colors.white,
                              ) 
                            : RaisedButton.icon(
                                onPressed: () {

                                  print(snapshot.data.docs[index]['bookingId']);
                                  
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResultsPage(pretestId: snapshot.data.docs[index]['bookingId'])),
                                    );
                                  
                                },
                                icon: Icon(Icons.assignment_late),
                                label: Text('Completed'),
                                color: Colors.grey,
                                textColor: Colors.black,
                              ) ,
                            children: <Widget>[
                              // Expanded Contents
                              ListTile(
                                leading: Icon(Icons.import_contacts),
                                title: Text('${snapshot.data.docs[index]['bookingData']['topic']}'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(Icons.place),
                                title: Text('${snapshot.data.docs[index]['bookingData']['location']}'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(Icons.event),
                                title: Text(DateFormat.yMMMEd().format(parsedDate)),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(Icons.access_time),
                                title: Text('${snapshot.data.docs[index]['bookingData']['timeStart']} - ${snapshot.data.docs[index]['bookingData']['timeEnd']}'),
                                dense: true,
                              ),
                              ListTile(
                                leading: Icon(Icons.attach_money),
                                title: Text('P ${snapshot.data.docs[index]['bookingData']['rate']}.00'),
                                dense: true,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                    );
              },
            );

          }
        );
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

  // Stream getBookings() {
  //   Stream ret = _model.getTutorBookings(widget.uid);
  //   return ret;
  // }

  initState() {
    super.initState();
   // bookingModel = new BookingsModel();
  }

  @override
  Widget build(BuildContext context) {
        return StreamBuilder(
          stream: _model.getTutorBookings(widget.uid),
          builder: (context, snapshot){
            if(snapshot.data == null){
              return Center(child:CircularProgressIndicator());
            }
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
               //return new  Text(snapshot.data.docs[index]['bookingData']['student_firstName'].toString());
                //var booking = snapshot.data.docs[index]['bookingData'];
                var parsedDate = DateTime.parse(snapshot.data.docs[index]['bookingData']['date']);
                if(snapshot.data.docs[index]['bookingData']['booking_status'] == 'Pending'){
                  check = true;
                }else if(snapshot.data.docs[index]['bookingData']['booking_status'] == 'Accepted'){
                  check = false;
                }

                component.pretestBtn = new component.TrailingButton(
                    buttonColor: Colors.blue.shade800, 
                    buttonTitle: 'Pretest', 
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), 
                    icon: Icon(Icons.assignment), 
                    visible: !check, 
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewTutorialPage(studentData: snapshot.data.docs[index])),
                      );
                    }
                  );

                // if(snapshot.data.docs[index]['pretestData']['pretest_answeredStatus'] == '0'){
                //   component.pretestBtn = new component.TrailingButton(
                //     buttonColor: Colors.blue.shade800, 
                //     buttonTitle: 'Pretest', 
                //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), 
                //     icon: Icon(Icons.assignment), 
                //     visible: !check, 
                //     onPressed: (){
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => ViewTutorialPage(studentData: snapshot.data.docs[index])),
                //       );
                //     }
                //   );
                // }else if(snapshot.data.docs[index]['pretestData']['pretest_answeredStatus'] == '1'){
                //   component.pretestBtn = new component.TrailingButton(
                //     buttonColor: Colors.grey, 
                //     buttonTitle: 'Completed', 
                //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), 
                //     icon: Icon(Icons.assignment_late), 
                //     visible: !check, 
                //     onPressed: (){
                //       Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                           builder: (context) => ResultsPage(pretestId: snapshot.data.docs[index]['bookingId'])),
                //                     );
                //     }
                //   );
                //   // RaisedButton.icon(
                //   //               onPressed: () {

                //   //                 print(snapshot.data.docs[index]['bookingId']);
                                  
                //   //                 Navigator.push(
                //   //                     context,
                //   //                     MaterialPageRoute(
                //   //                         builder: (context) => ResultsPage(pretestId: snapshot.data.docs[index]['bookingId'])),
                //   //                   );
                                  
                //   //               },
                //   //               icon: Icon(Icons.assignment_late),
                //   //               label: Text('Completed'),
                //   //               color: Colors.grey,
                //   //               textColor: Colors.black,
                //   //             ); 
                // }
                return new Card(
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    children: [
                      ExpansionTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/opentutorials.jpg'),
                        ),
                        title: Text('${snapshot.data.docs[index]['bookingData']['student_firstName']} ${snapshot.data.docs[index]['bookingData']['student_lastName']}'),
                       // subtitle: Text(booking['username'], overflow: TextOverflow.ellipsis),
                        trailing: component.pretestBtn,
                        children: [
                          ListTile(
                            leading: Icon(Icons.import_contacts),
                            title: Text(snapshot.data.docs[index]['bookingData']['topic']),
                            dense: true
                          ),
                          ListTile(
                            leading: Icon(Icons.place),
                            title: Text(snapshot.data.docs[index]['bookingData']['location']),
                            dense: true
                          ),
                          ListTile(
                            leading: Icon(Icons.event),
                            title: Text(DateFormat.yMMMEd().format(parsedDate)),
                            dense: true,
                          ),
                          ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text('${snapshot.data.docs[index]['bookingData']['timeStart']} - ${snapshot.data.docs[index]['bookingData']['timeEnd']}'),
                            dense: true
                          ),
                          ListTile(
                            leading: Icon(Icons.attach_money),
                            title: Text('P ${snapshot.data.docs[index]['bookingData']['rate']}.00'),
                            dense: true
                          )
                        ],
                      ),

                      Row(
                        children: [
                          component.acceptBtn = new component.TrailingButton(
                            buttonColor: Colors.green,
                            buttonTitle: 'Accept Booking', 
                            icon: Icon(Icons.assignment), 
                            onPressed: (){
                              print(snapshot.data.docs[index]['bookingId']);
                              _model.updateBookingStatus(snapshot.data.docs[index]['bookingId'], 1);
                            }, 
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10), 
                            visible: check,
                          ),

                          component.cancelBtn = new component.TrailingButton(
                            
                            onPressed: (){
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
                  )
                );
              },
            );

          }
        );
      
  }
}

