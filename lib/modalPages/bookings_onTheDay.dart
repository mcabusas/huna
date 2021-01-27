import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/modalPages/tutorialInSession.dart';
import 'package:huna/secondaryPages/viewStudentProfile.dart';

void main() => runApp(OnTheDay());

class OnTheDay extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: OnTheDayPage(),
    );
  }
}

class OnTheDayPage extends StatefulWidget {
  @override
  _OnTheDayState createState() => _OnTheDayState();
}

class _OnTheDayState extends State<OnTheDayPage> {
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
        title: Text('On The Day'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                              AssetImage('assets/images/profile.jpg'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'John Smith',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('@hunabetatester'),
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
                              AssetImage('assets/images/tutor.jpg'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Jane Doe',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('@betatutor'),
                    ],
                  ),
                ],
              ),
              Center(child: SizedBox(height: 20)),
              // BOOKING DETAILS
              Center(
                child: Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.import_contacts),
                title: Text('Data Structures'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.place),
                title: Text('I-cha!, Rosedale'),
                dense: true,
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text('February 10, 2020'),
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
              Center(child: SizedBox(height: 20)),
              // BUTTONS                             
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TutorialInSession()),
                      );
                  },
                  icon: Icon(Icons.assignment),
                  label: Text('Begin Tutorial'),
                  color: Colors.deepPurple, 
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
