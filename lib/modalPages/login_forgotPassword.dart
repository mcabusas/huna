import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huna/login/login.dart';
import '../services/auth_services.dart';

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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}



class ForgotPassword extends StatefulWidget {
  @override
  State createState() => new ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  AuthServices _services = new AuthServices();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Reset Password'),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              new TextFormField(
                                onChanged: (value){
                                  setState(() {
                                    email = value;
                                  });
                                },
                                validator: (value) {
                                  if(value == null) {
                                    return 'Please enter your email.';
                                  }
                                  return null;
                                },
                                decoration: new InputDecoration(
                                  labelText: "Email",
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
                                      "A link will be sent to your email that will allow you to change your password.",
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
                                      "Please change your password and try to login once again.",
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
                                    width:
                                        MediaQuery.of(context).size.width / 1.18,
                                    child: MaterialButton(
                                      color: Colors.cyan,
                                      textColor: Colors.white,
                                      child: Text(
                                        "Send",
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      onPressed: () async {
                                        if(_formKey.currentState.validate()){
                                          print(email);
                                          bool ret = await _services.forgotPassword(email);
                                          if(ret){
                                            _showDialog(context);
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "There was an error, please verify if you've entered the correct email.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIos: 1,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                          }
                                        }
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
