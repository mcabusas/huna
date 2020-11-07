import 'package:flutter/material.dart';
import 'package:huna/modalPages/signup.dart';
import 'package:huna/modalPages/login_forgotPassword.dart';
import 'package:huna/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class User{
  String username, id, tutorID, fName, lName, rate;

  User({this.fName, this.id, this.lName, this.username, this.tutorID, this.rate});
}

User u = new User();

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}



class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  TextEditingController user = new TextEditingController();
  TextEditingController password = new TextEditingController();
  
  
  
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;
  bool retVal = false;
  
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login(u);
    }else{
      print('not valid');
    }
    
    

     
  }

    loginToast(String toast) {
      return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white);
    }

   login(User u) async {
     final response = await http.post("http://192.168.1.7/huna/database_files/classes/controllers/logincontroller.class.php", body: {
        "username": 'joerogan',
        "password": '1244',
      });

      
      final data = jsonDecode(response.body);
      print(data.toString());

      // u.value = data['value'];
      // String msg = data['message'];

      

      if(data != "ERROR"){
        
        u.username = data['username'];
        u.id = data['user_id'];
        u.fName = data['user_firstName'];
        u.lName = data['user_lastName'];
        u.tutorID = data['tutor_id'];
        u.rate = data['rate'];
        print("This is your tutorID ${u.tutorID}");
        setState(() {
          savePref(u.username, u.id, u.fName, u.lName, u.tutorID).then((bool committed){
            Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                child: DashboardPage(u: u)),
            (Route<dynamic> route) => false);
          });
        });
        loginToast('Login Successful');


      }else if(data == 'ERROR'){
        print("fail");
        loginToast('Username or password is incorrect.');
      }else if(response.statusCode != 200){
        String msg = 'We are currently facing server problems, please try again later.';
        print(msg);
        loginToast(msg);
      }
      
     
      
    }
    Future<bool> savePref(String username, String id, String fName, String lName, String tutorID) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        preferences.setString("username", username);
        preferences.setString("id", id);
        preferences.setString("firstName", fName);
        preferences.setString("lastName", lName);
        preferences.setString("tutorID", tutorID);
        String e = preferences.getString('username');
        print(e);
        return preferences;
      });

      
    }

    

    

  @override
  void initState() {
    super.initState();
    //getPref();
    
    _iconAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 500,
      ),
    );
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/bgk.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlutterLogo(
                size: _iconAnimation.value * 100,
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
                  "Encouraging independent learning.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
              new Form(
                key: _key,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          controller: user,
                          decoration: new InputDecoration(
                            labelText: "Username",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        new TextFormField(
                          controller: password,
                          decoration: new InputDecoration(
                            labelText: "Password",
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        new SizedBox(
                          height: 15.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new MaterialButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 35.0),
                              child: new Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => ForgotPassword()
                                    ),
                                  );
                                
                                                                
                              },
                            ),
                          ],
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new MaterialButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 35.0),
                              color: Colors.blue.shade900,
                              textColor: Colors.white,
                              child: new Text(
                                "Login",
                                style: TextStyle(fontSize: 15.0),
                              ),
                              onPressed: ()  {
                                login(u);
                              },
                            ),
                            new SizedBox(
                              width: 20.0,
                            ),
                            new OutlineButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 30.0),
                              borderSide: BorderSide(
                                color: Colors.grey[700],
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                              textColor: Colors.white,
                              child: new Text("Sign Up"),
                              onPressed: () {
                              
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => SignUp()
                                  ),
                                );   
                              },
                            ),
                            
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
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
    );
  }
}

  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }*/