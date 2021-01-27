import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/login/login.dart';
import 'package:huna/payment.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/favorites.dart';
import 'package:huna/feedback.dart';
import 'package:huna/messages.dart';
import 'package:huna/profile/myProfile.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'drawer_model.dart';



class SideDrawer extends StatefulWidget{

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  DrawerModel drawerModel = new DrawerModel();
  

  Future<Map<String, dynamic>> initAwait() async {
    Future<Map<String,dynamic>> ret = drawerModel.userProfile();
    return ret;
  }

  // initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context){

    return FutureBuilder(
      future: initAwait(),
      builder: (context,  AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                accountName: Text('${snapshot.data['firstName']} ${snapshot.data['lastName']}'),
                  accountEmail: Text(snapshot.data['username']), //Use Username Instead
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  onDetailsPressed: () async{
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
                      //print(snapshot.data);
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
                      // signOut();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      // );
                    }),
              ],
            ),
          );
        }else{
          return Drawer(
            child: Center(child: CircularProgressIndicator(),)
          );
        }
      },
    );
    
  }
}
 
