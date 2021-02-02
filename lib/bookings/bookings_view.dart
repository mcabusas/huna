import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/login/login.dart';
import 'package:huna/modalPages/bookings_viewTutorial.dart';
import 'package:huna/historyPages/bookingHistory.dart';
import 'package:http/http.dart' as http;
import 'package:huna/drawer/drawer.dart';
import 'package:intl/intl.dart';
import 'package:huna/components/buttons.dart' as component;
import 'bookings_model.dart';

//import '../../modalPages/bookings_answerPretest.dart';


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

  // Widget bottomNavBar(){
  //   if(u.tutorID == null){
  //     return null;
  //   }else{
  //     return BottomAppBar(
  //       shape: CircularNotchedRectangle(),
  //       notchMargin: 4,
  //       clipBehavior: Clip.antiAlias,
  //       child: BottomNavigationBar(
  //         currentIndex: _selectedIndex,
  //         items: [
  //           BottomNavigationBarItem(
  //             icon: Icon(Icons.school),
  //             title: Text('Student'),
  //           ),
  //           BottomNavigationBarItem(
  //             icon: Icon(Icons.local_cafe),
  //             title: Text('Tutor'),
  //           ),
  //         ],
  //         onTap: (index) {
  //           setState(() {
  //             _selectedIndex = index;
  //             if(index == 0){
  //               page = 0;
  //             }else if(index == 1){
  //               page = 1;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   }
  // }

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
      body: MainWidget(),
      //bottomNavigationBar: bottomNavBar(),
    );
  }
}

class StudentModeWidget extends StatefulWidget {

  @override
  _StudentModeWidgetState createState() => _StudentModeWidgetState();
}

class _StudentModeWidgetState extends State<StudentModeWidget> {

  

  // Future getBooking() async{
  //    final response = await http.get(
  //     Uri.encodeFull("http://www.hunacapstone.com/api/classes/controllers/getBookingsController.class.php?id=${u.id}&flag=0"),
  //     headers: {
  //       "Accept": 'application/json',
  //     }
  //   );
  //   if(response.statusCode == 200){
  //     setState(() {
  //       jsonData = jsonDecode(response.body);
  //       isLoading = true;
  //     });
  //   }
  //   print(jsonData.length);
  // }

  // Future setStatusBooking(var bookingId, int statusFlag) async{
  //   final response = await http.post("http://www.hunacapstone.com/api/classes/controllers/setBookingStatusController.class.php", body: {
  //       "booking_id": bookingId,
  //       "flag": '1',
  //       "statusFlag": statusFlag.toString(),
  //     });
  //   // if(response.statusCode == 200){
  //   //   setState(() {
  //   //      retVal = jsonDecode(response.body);

  //   //   });
  //   // }
  // }

  BookingsModel bookingModel;
  Stream retVal;

  Stream getBookings() {
    bookingModel = new BookingsModel();
    Stream ret = bookingModel.fetchBookings();
    return ret;
  }


  void initState(){
    super.initState();
    retVal = getBookings();
    print(retVal);
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => AnswerPretest()),
                          // );
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
                          title: Text('${jsonData[index]['xmlData']['timeStart']} - ${jsonData[index]['xmlData']['timeEnd']}'),
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
            }
          },
        );
    }else{
      return Center(child:Container(height: 0, width: 0));
    }
  }
}



class TutorModeWidget extends StatefulWidget {
  @override
  _TutorModeWidgetState createState() => _TutorModeWidgetState();
}

class _TutorModeWidgetState extends State<TutorModeWidget> {
  
  bool check;
  BookingsModel bookingModel;
  Stream retVal;

  Stream getBookings() {
    bookingModel = new BookingsModel();
    Stream ret = bookingModel.fetchBookings();
    return ret;
  }

  initState() {
    super.initState();
    retVal = getBookings();
    print(retVal);
   // bookingModel = new BookingsModel();
  }

  @override
  Widget build(BuildContext context) {
        return StreamBuilder(
          stream: retVal,
          builder: (context, snapshot){
            if(snapshot.data == null){
              return Center(child:CircularProgressIndicator());
            }
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                DocumentSnapshot booking = snapshot.data.docs[index];
                var parsedDate = DateTime.parse(booking['date']);
                if(booking['booking_status'] == 'Pending'){
                  check = true;
                }else if(booking['booking_status'] == 'Accepted'){
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
                      MaterialPageRoute(builder: (context) => ViewTutorialPage(studentData: jsonData[index])),
                    );
                  }
                );
                return new Card(
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    children: [
                      ExpansionTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/opentutorials.jpg'),
                        ),
                        title: Text('${booking['firstName']} ${booking['lastName']}'),
                        subtitle: Text(booking['username'], overflow: TextOverflow.ellipsis),
                        trailing: component.pretestBtn,
                        children: [
                          ListTile(
                            leading: Icon(Icons.import_contacts),
                            title: Text(booking['topic']),
                            dense: true
                          ),
                          ListTile(
                            leading: Icon(Icons.place),
                            title: Text(booking['location']),
                            dense: true
                          ),
                          ListTile(
                            leading: Icon(Icons.event),
                            title: Text(DateFormat.yMMMEd().format(parsedDate)),
                            dense: true,
                          ),
                          ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text('${booking['timeStart']} - ${booking['timeEnd']}'),
                            dense: true
                          ),
                          ListTile(
                            leading: Icon(Icons.attach_money),
                            title: Text('250.00'),
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
                              print(booking.id.runtimeType);
                              bookingModel.updateBookingStatus(booking.id, 1);
                            }, 
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10), 
                            visible: check,
                          ),

                          component.cancelBtn = new component.TrailingButton(
                            
                            onPressed: (){
                              print(booking.id.runtimeType);
                              bookingModel.updateBookingStatus(booking.id, 0);
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