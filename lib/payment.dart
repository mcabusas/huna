import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/historyPages/transactions.dart';
import 'package:huna/favorites/favorites.dart';
import 'package:huna/feedback/feedback.dart';
import 'package:huna/login/login.dart';
import 'package:huna/messages/messages.dart';
import 'package:huna/profile/myProfile.dart';
import 'package:huna/drawer/drawer.dart';

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
      drawer: SideDrawer(),
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
