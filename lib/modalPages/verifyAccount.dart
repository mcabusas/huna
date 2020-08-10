import 'package:flutter/material.dart';
import 'package:huna/dashboard.dart';
import 'package:huna/modalPages/signup.dart';

void main() => runApp(VerifyAccount());

class VerifyAccount extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: VerifyAccountPage(),
    );
  }
}

class VerifyAccountPage extends StatefulWidget {
  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}


class _VerifyAccountState extends State<VerifyAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            }),
        title: Text('Verify Account'),
      ),
      body: SafeArea(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/images/bgk.jpg"),
              fit: BoxFit.cover,
              color: Colors.black87,
              colorBlendMode: BlendMode.darken,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[                    
                  SizedBox(
                    height: 250.0,
                  ),
                  Text(
                    "Please enter the verification code sent to your number.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[                                                                       
                      new Form(
                        child: new Theme(
                          data: new ThemeData(
                            brightness: Brightness.dark,
                            primarySwatch: Colors.grey,
                            inputDecorationTheme: new InputDecorationTheme(
                                labelStyle: new TextStyle(
                              color: Colors.white54,
                              fontSize: 15.0,
                            )),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: new TextFormField(
                                    decoration: new InputDecoration(
                                      labelText: "Verification Code",
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                new Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                ),
                                new SizedBox(
                                  height: 50.0,
                                ),
                                new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new MaterialButton(                                     
                                      color: Colors.deepPurple,
                                      textColor: Colors.white,
                                      child: new Text(
                                        "Proceed To Dashboard",
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  DashboardPage()),
                                        );
                                      },
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
