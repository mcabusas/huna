import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huna/login/login.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


var page;
var jsonData;
int _selectedIndex = 0;
final tabs = [StudentHistoryMode(), TutorHistoryMode()];
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

class BookingHistoryPage extends StatefulWidget {

  final tutorID;

  const BookingHistoryPage({this.tutorID});

  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistoryPage> {


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
  //           //print(_selectedIndex);
  //           print(page);
  //         },
  //       ),
  //     );
  //   }
  // } 


  @override
  Widget build(BuildContext context) {
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
        title: Text('Booking History'),
      ),
      body: MainWidget(),
      //bottomNavigationBar: bottomNavBar(),
    );
  }
}

class StudentHistoryMode extends StatefulWidget {
  @override
  _StudentHistoryModeState createState() => _StudentHistoryModeState();
}

class _StudentHistoryModeState extends State<StudentHistoryMode> {

  //  Future getBooking() async{
  //    final response = await http.get(
  //     Uri.encodeFull("https://hunacapstone.com/database_files/bookingHistory.php?id=${u.id}&page=$page"),
  //     headers: {
  //       "Accept": 'application/json',
  //     }
  //   );
  //   if(response.statusCode == 200){
  //     setState(() {
  //       jsonData = jsonDecode(response.body);
  //       isLoading = true;
  //     });
  //     print(jsonData);
  //   }
  // }

  // void initState(){
  //   super.initState();
  //   getBooking();
  // }

  @override
  Widget build(BuildContext context) {
    if(isLoading == true) {
      if(jsonData == null){
        return new Container();
      }
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        itemCount: jsonData == null ? 0 : jsonData.length,
        // ignore: missing_return
        itemBuilder: (BuildContext context, int index) {
          var parsedDate = DateTime.parse(jsonData[index]['date']);
            Widget trailingLabel;
            if(jsonData[index]['booking_status'] == 'Finished'){
               trailingLabel =  RaisedButton.icon(
                      elevation: 0,
                      onPressed: () {},
                      icon: Icon(Icons.cancel, color: Colors.transparent),
                      label: Text('Completed'),
                      color: Colors.transparent,
                      textColor: Colors.lightGreen,
                    );
            }else if(jsonData[index]['booking_status'] == 'Declined'){
              trailingLabel =  RaisedButton.icon(
                      elevation: 0,
                      onPressed: () {},
                      icon: Icon(Icons.cancel, color: Colors.transparent),
                      label: Text('Cancelled'),
                      color: Colors.transparent,
                      textColor: Colors.red.shade800,
                    );
            }
            return new Card(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                children: <Widget>[
                  // Per Booking, PRETEST
                  ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                    ),
                    title: Text('${jsonData[index]['user_firstName']} ${jsonData[index]['user_lastName']}'),
                    subtitle:
                        Text('${jsonData[index]['username']}', overflow: TextOverflow.ellipsis),
                    trailing: trailingLabel,
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
                        title: Text('${jsonData[index]['xmlData']['timestart']} ${jsonData[index]['xmlData']['timeend']}'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('${jsonData[index]['rate']}.00'),
                        dense: true,
                      ),
                    ],
                  ),
                ],
              ),
            );
        },
        );
    }else{
      return Center(child:CircularProgressIndicator());
    }
  }
}

class TutorHistoryMode extends StatefulWidget {
  @override
  _TutorHistoryModeState createState() => _TutorHistoryModeState();
}

class _TutorHistoryModeState extends State<TutorHistoryMode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('fast as fuck nigga'),
      
    );
  }
}

/*Future getHistory(var id, var page, Function x) async {
  final response = await http.get(
      Uri.encodeFull("https://hunacapstone.com/database_files/getBooking.php?id=${u.id}&page=$page"),
      headers: {
        "Accept": 'application/json',
      }
    );
    if(response.statusCode == 200){
      Function setState = x;
      print(jsonData);
    }

}*/
