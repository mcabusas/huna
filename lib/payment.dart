import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/historyPages/transactions.dart';
import 'package:huna/favorites.dart';
import 'package:huna/feedback.dart';
import 'package:huna/login/login.dart';
import 'package:huna/messages/messages.dart';
import 'package:huna/profile/myProfile.dart';

void main() => runApp(Payment());

class Payment extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Transactions()),
              );
            },
          ),
        ],
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
              onDetailsPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile()),
                );
              },
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Messages()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
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
                title: Text('Feedback'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackPage()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        child: Column(
          children: <Widget>[
            Text(
              'Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            ListView(
              padding: EdgeInsets.all(15),
              shrinkWrap: true,
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Cash'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
