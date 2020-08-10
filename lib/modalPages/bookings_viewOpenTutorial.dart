import 'package:flutter/material.dart';
import 'package:huna/bookings.dart';

void main() => runApp(ViewOpenTutorial());

class ViewOpenTutorial extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: ViewOpenTutorialPage(),
    );
  }
}

class ViewOpenTutorialPage extends StatefulWidget {
  @override
  _ViewOpenTutorialState createState() => _ViewOpenTutorialState();
}

class _ViewOpenTutorialState extends State<ViewOpenTutorialPage> {
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
        title: Text('Open Tutorial'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: 75,
                  height: 75,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'John Smith',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Center(child: Text('@hunabetatester')),
              Center(child: SizedBox(height: 20)),
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

              // BOOKING DETAILS
              // TOPIC
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.import_contacts),
                  labelText: 'Topic',
                ),
              ),
              // LOCATION
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.place),
                  labelText: 'Location',
                ),
              ),
              // MAX NUMBER OF STUDENTS
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.people),
                  labelText: 'Max Number of Students',
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),
              // FEE PER STUDENT
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.attach_money),
                  labelText: 'Fee per Student',
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),
              // DATE
              
              // TIME START

              // TIME END

            ],
          ),
        ),
      ),
    );
  }
}
