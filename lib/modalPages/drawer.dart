import 'package:flutter/material.dart';
import 'package:huna/login.dart';
import 'package:huna/payment.dart';
import 'package:huna/bookings.dart';
import 'package:huna/favorites.dart';
import 'package:huna/feedback.dart';
import 'package:huna/messages.dart';
import 'package:huna/secondaryPages/myProfile.dart';
import 'package:huna/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SideDrawer extends StatelessWidget{

  signOut() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
    }

  @override
  Widget build(BuildContext context){
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('${u.fName} ${u.lName} ${u.id}'),
              accountEmail: Text(u.username), //Use Username Instead
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
                  signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }),
          ],
        ),
      );
  }
}
 
