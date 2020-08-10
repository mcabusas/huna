import 'package:flutter/material.dart';
import 'package:huna/bookings.dart';
import 'package:huna/main.dart';
import 'package:huna/payment.dart';

void main() => runApp(BookingHistory());

class BookingHistory extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: BookingHistoryPage(),
    );
  }
}

class BookingHistoryPage extends StatefulWidget {
  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistoryPage> {
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('John Smith'),
              accountEmail: Text('@hunabetatester'), //Use Username Instead
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.date_range),
                title: Text('Bookings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Bookings()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Messages'),
                onTap: () {}),
            ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {}),
            ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Booking History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingHistory()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Payment'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Payment()),
                  );
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.info),
                title: Text('About Us'),
                onTap: () {}),
            ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // PER BOOKING
            Container(
              // height: 1000,
              // margin: EdgeInsets.only(bottom: 10.0),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                children: <Widget>[
                  // Per Booking, PRETEST
                  ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/opentutorials.jpg'),
                    ),
                    title: Text('James Todd'),
                    subtitle:
                        Text('@jamestodd', overflow: TextOverflow.ellipsis),
                    trailing: RaisedButton.icon(
                      elevation: 0,
                      onPressed: () {},
                      icon: Icon(Icons.cancel, color: Colors.transparent),
                      label: Text('Completed'),
                      color: Colors.transparent,
                      textColor: Colors.lightGreen,
                    ),
                    children: <Widget>[
                      // Expanded Contents
                      ListTile(
                        leading: Icon(Icons.import_contacts),
                        title: Text('Flutter for Beginners'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.place),
                        title: Text('Talamban Campus, USC'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.event),
                        title: Text('February 19, 2020'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text('10:30 AM'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('P 500.00'),
                        dense: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // PER BOOKING
            Container(
              // height: 1000,
              // margin: EdgeInsets.only(bottom: 10.0),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                children: <Widget>[
                  // Per Booking, PRETEST
                  ExpansionTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                    ),
                    title: Text('Jack Dawson'),
                    subtitle:
                        Text('@jackdawson', overflow: TextOverflow.ellipsis),
                    trailing: RaisedButton.icon(
                      elevation: 0,
                      onPressed: () {},
                      icon: Icon(Icons.cancel, color: Colors.transparent),
                      label: Text('Cancelled'),
                      color: Colors.transparent,
                      textColor: Colors.red.shade800,
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
                        title: Text('February 19, 2020'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text('10:30 AM'),
                        dense: true,
                      ),
                      ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('P 500.00'),
                        dense: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
