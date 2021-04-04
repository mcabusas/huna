import 'dart:async';
import 'package:flutter/material.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

String id;
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();    
    initAwait();
  }

  initAwait() async {
    await test();
  }

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<void> test() async{

    Map<String, dynamic> data = {
      "firstName": "Balot",
      "lastName": "test"
    };

    HttpsCallable callable = functions.httpsCallable('test');
    try {
      await callable(data).then((value) => {
        print(value.data['firstName'])
      });
    } catch (e){
      print(e.toString());
    }
  }


  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('uid');
    print(id);
    return Timer(Duration(seconds: 5), onDoneLoading(id));
  }

  onDoneLoading(String id) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => id == null? LoginPage() : DashboardPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/bgk.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.redAccent,
          //   ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[              
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: new Text(
                          "Welcome to",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            letterSpacing: 3.5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      new FlutterLogo(
                        size: 150,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: new Text(
                          "HUNA",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      // backgroundColor: Colors.blue,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text(
                      "Encouraging independant learning.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
