import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:huna/bookings/bookings_view.dart';

void main() => runApp(CreateOpenTutorial());

class CreateOpenTutorial extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: CreateOpenTutorialPage(),
    );
  }
}

class CreateOpenTutorialPage extends StatefulWidget {
  @override
  _CreateOpenTutorialState createState() => _CreateOpenTutorialState();
}

class _CreateOpenTutorialState extends State<CreateOpenTutorialPage> {
  DateTime _dateTime;
  TimeOfDay _timeStart;
  TimeOfDay _timeEnd;

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
        title: Text('Create Open Tutorial'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Container(
                width: 75,
                height: 75,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'John Smith',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('@hunabetatester'),
              SizedBox(height: 20),
              Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.import_contacts),
                  labelText: 'Topic',
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.place),
                  labelText: 'Location',
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.people),
                  labelText: 'Max Number of Students',
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),

              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.attach_money),
                  labelText: 'Fee per Student',
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
                            : DateFormat('EEE, MMMM d, yyyy')
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
                        _timeStart == null
                            ? ''
                            : _timeStart.format(context)
                      ),
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
                        _timeEnd == null
                            ? ''
                            : _timeEnd.format(context)
                      ),
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
              SizedBox(height: 20),
              SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.done),
                      label: Text('Post Open Tutorial'),
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                    ),
                  ),

            ],
          ),
        ),
      ),
    );
  }
}
