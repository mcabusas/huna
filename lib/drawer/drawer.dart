import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/login/login.dart';
import 'package:huna/payment/payment.dart';
import 'package:huna/services/auth_services.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/favorites/favorites.dart';
import 'package:huna/feedback/feedback.dart';
import 'package:huna/messages/messages.dart';
import 'package:huna/profile/myProfile.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'drawer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/profilePicture.dart';



class SideDrawer extends StatefulWidget{

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  DrawerModel drawerModel = new DrawerModel();
  SharedPreferences sp;
  AuthServices _authServices = new AuthServices();
  String uid, firstName, lastName;
  

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
      firstName = sp.getString('firstName');
      lastName = sp.getString('lastName');
    });
  }

  initState() {
    super.initState();
    initAwait();
  }

  @override
  Widget build(BuildContext context){
    

    return Drawer(
            child: FutureBuilder(
              future: drawerModel.getStatus(),
              builder: (context, AsyncSnapshot snapshot) {
                Widget ret;
                if(snapshot.connectionState == ConnectionState.waiting) {
                  ret = Container(child: Center(child: CircularProgressIndicator()));
                }
                if(snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.data == true) {
                    ret = ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                        accountName: Text('${firstName} ${lastName}'),
                          //accountEmail: Text(snapshot.data['username']), //Use Username Instead
                          currentAccountPicture: FutureBuilder(
                            future: drawerModel.getPicture(uid),
                            builder: (BuildContext context, AsyncSnapshot snapshot){  
                              Widget retVal;
                              if(snapshot.connectionState == ConnectionState.waiting){
                                retVal = Container(child: CircularProgressIndicator());
                              }
                              if(snapshot.connectionState == ConnectionState.done){
                                retVal = ClipOval(child: ProfilePicture(url: snapshot.data));
                              }

                              return retVal;
                            },
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
                              _authServices.signOut(sp.getString('uid')).then((value) => {

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => LoginPage(),
                                  ),
                                  (route) => false,
                                )

                              });
                            }),
                      ],
                    );
                  }else {
                    ret = ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                        accountName: Text('${firstName} ${lastName}'),
                          //accountEmail: Text(snapshot.data['username']), //Use Username Instead
                          currentAccountPicture: FutureBuilder(
                            future: drawerModel.getPicture(uid),
                            builder: (BuildContext context, AsyncSnapshot snapshot){  
                              Widget retVal;
                              if(snapshot.connectionState == ConnectionState.waiting){
                                retVal = Container(child: CircularProgressIndicator());
                              }
                              if(snapshot.connectionState == ConnectionState.done){
                                retVal = ClipOval(child: ProfilePicture(url: snapshot.data));
                              }

                              return retVal;
                            },
                          ),
                          onDetailsPressed: () async{
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyProfile()),
                            );
                          },
                        ),
                        Divider(),

                        Container(
                          child: Column(
                            children: [
                              Icon(Icons.error, size: 40),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                                child: Text('Your account is currently inactive. \n\nPlease contact hunamobileapp@gmail.com for more details.', style: TextStyle(fontSize: 18)),
                              )
                            ]
                          )
                        ),
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
                              _authServices.signOut(sp.getString('uid')).then((value) => {

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => LoginPage(),
                                  ),
                                  (route) => false,
                                )

                              });
                            }),
                      ],
                    );
                  }
                }

                return ret;
                
              }
            )
          );
    
  }
}
 
