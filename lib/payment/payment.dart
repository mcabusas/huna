import 'package:flutter/material.dart';
import 'package:huna/historyPages/transactions.dart';
import 'package:huna/drawer/drawer.dart';
import 'package:huna/payment/payment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String uid;

  initAwait() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
                     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.history),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Transactions()),
          //     );
          //   },
          // ),
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
                GestureDetector(
                  onTap: () {
                  },
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Add Card'),

                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Cash'),

                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
