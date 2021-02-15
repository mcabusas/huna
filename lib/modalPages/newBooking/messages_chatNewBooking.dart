import 'package:huna/dashboard/dashboard.dart';
import '../map.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'messages_chatNewBooking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String formattedTimeOfStart; 
  String formattedTimeOfEnd;
  Map retVal;

  Map<String, dynamic> bookingData = {
      'student_id': '',
      'student_firstName': '',
      'student_lastName': '',
      'tutor_firstName': '',
      'tutor_lastName': '',
      'tutor_userid': '',
      'tutor_id': '',
      'date': '',//_dateTime.toString(),
      'timeStart': '',//formattedTimeOfStart,
      'timeEnd': '',//formattedTimeOfEnd,
      'topic': '',
      'location': '',
      'numberOfStudents': '',
      'locationId': '',
      'booking_status': 'Pending',
      'rate': ''
    };


  _location(BuildContext context) async {
    retVal = await Navigator.push(context, 
      new MaterialPageRoute(builder: (context) => new MapSample())
    );
    bookingData['locationId'] = retVal['placeId'];
    bookingData['location'] = retVal['description'];
  }

  // Future insertBooking() async{

  //   CollectionReference collectionReference = FirebaseFirestore.instance.collection('bookings');
  //   collectionReference.add(body);
    
  //   // final response = await http.post('http://www.hunacapstone.com/api/classes/controllers/insertBookingsController.class.php', body: body);
  //   // if(response.statusCode == 200){
  //   //   //if(!mounted) return;
  //   //   setState(() {
  //   //      jsonData = jsonDecode(response.body);
  //   //   });
  //   //   print(jsonData);
  //   // }
  // }

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
  void initState(){
    super.initState();
    initAwait();
     //print(widget.tutorInfo);
    

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Tutorial Booking'),
      ),
      body: SingleChildScrollView(
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
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/tutor2.jpg'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${firstName} ${lastName}',
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
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile.jpg'),
                        ),
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
                onChanged: (value){
                  bookingData['topic'] = value;
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.import_contacts),
                  labelText: 'Topic',
                ),
              ),

              RaisedButton.icon(
                onPressed: () {
                  _location(context);
                },
                icon: Icon(Icons.place),
                label: Text('Search for Location'),
                color: Colors.blue.shade800,
                textColor: Colors.white,
              ),

              TextFormField(
                onChanged: (value){
                  setState(() {
                    bookingData['location'] = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.place),
                  labelText: retVal == null ? '': retVal['description'],
                ),
              ),

              TextFormField(
                onChanged: (value){
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
                      child: Text(
                          _timeStart == null ? '' : _timeStart.format(context)),
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
                              final MaterialLocalizations localizations = MaterialLocalizations.of(context);
                              formattedTimeOfStart = localizations.formatTimeOfDay(_timeStart);
                              bookingData['timeStart'] = formattedTimeOfStart;
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
                              final MaterialLocalizations localizations = MaterialLocalizations.of(context);
                              formattedTimeOfEnd = localizations.formatTimeOfDay(_timeEnd);
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
                    Text("P ${widget.tutorInfo['rate']}.00", style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // IF STUDENT SENDS BOOKING REQUEST:
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton.icon(
                  onPressed: () {
                    _model.createBooking(bookingData, widget.chatRoomId);
                    //insertBooking();
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Bookings()),
                    );*/
                  },
                  icon: Icon(Icons.assignment),
                  label: Text('Send Booking Request'),
                  color: Colors.deepPurple,
                  textColor: Colors.white,
                ),
              ),

              // IF TUTOR ACCEPTS BOOKING REQUEST BUTTONS
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Bookings()),
                        );
                      },
                      icon: Icon(Icons.clear),
                      label: Text('Decline'),
                      color: Colors.red.shade800,
                      textColor: Colors.white,
                    ),
                    RaisedButton.icon(
                      onPressed: () {
                        print(bookingData);
                        //_model.createBooking(widget.tutorInfo, widget.chatRoomId);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => DashboardPage()),
                        // );
                      },
                      icon: Icon(Icons.check),
                      label: Text('Accept'),
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}