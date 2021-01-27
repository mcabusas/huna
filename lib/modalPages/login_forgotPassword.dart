import 'package:flutter/material.dart';
import 'package:huna/login/login.dart';
// import 'package:huna/modalPages/signup/signup.dart';

void _showDialog(context) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
       contentPadding: EdgeInsets.only(top: 30),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Request Sent!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              // textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              "Close",
              style: TextStyle(
                color: Colors.grey.shade900,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      );
    },
  );
}

void main() => runApp(ForgotPassword());

class ForgotPassword extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: ForgotPasswordPage(),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}


class _ForgotPasswordState extends State<ForgotPasswordPage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }),
        title: Text('Forgot Password'),
      ),
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/bgk.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          SingleChildScrollView(            
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new FlutterLogo(
                    size: 100.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0),
                    child: new Text(
                      "HUNA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                  Container(
                    child: new Text(
                      "Encouraging independant learning.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 50.0,
                  ),
                  new Form(
                    child: new Theme(
                      data: new ThemeData(
                        brightness: Brightness.dark,
                        primarySwatch: Colors.grey,
                        inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                            color: Colors.white54,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            new TextFormField(
                              decoration: new InputDecoration(
                                labelText: "Username",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  child: new Text(
                                    "A temporary password will be sent to the contact number registered to your username.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                new SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  width: 400.0,
                                  child: new Text(
                                    "Please login and change your password.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                             SizedBox(
                              height: 80.0,
                            ),
                             Row(                               
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                 SizedBox(
                                   width: MediaQuery.of(context).size.width / 1.18,
                                   child: MaterialButton(                                 
                                    color: Colors.cyan,
                                    textColor: Colors.white,
                                    child: Text(
                                      "Send Request",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                    onPressed: () {
                                      _showDialog(context);
                                    },
                                ),
                                 ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
