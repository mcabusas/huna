import 'package:flutter/material.dart';
import 'package:huna/signup/signup.dart';
import 'package:huna/modalPages/login_forgotPassword.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/constants.dart';
import '../dashboard/dashboard.dart';
import '../services/auth_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}



class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  String _email = '';
  String _password = '';

  AuthServices _services = new AuthServices();
  bool retVal;
  bool showSpinner = false;
  
  
  
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;
  
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
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
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: new Stack(
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
                            onChanged: (val){
                              setState(() {
                                _email = val;
                              });
                            },
                            decoration: new InputDecoration(
                              labelText: "Email",
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return 'Please enter your Email';
                              }else{
                                return null;
                              }
                              
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),

                          new TextFormField(
                            onChanged: (val){
                              setState(() {
                                _password = val;
                              });
                            },
                            decoration: new InputDecoration(
                              labelText: "Password",
                            ),
                            keyboardType: TextInputType.text,
                            validator: (String value){
                              if(value.isEmpty){
                                return 'Please enter your password';
                              }else{
                                return null;
                              }
                            },
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
                          Row(
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
                                onPressed: () async {
                                 if(_key.currentState.validate()){

                                   setState(() {
                                     showSpinner = true;
                                   });

                                   try{

                                    retVal =  await _services.login(_email, _password);
                                    if(retVal == true){
                                      setState(() {
                                        showSpinner = false;
                                      });

                                      Fluttertoast.showToast(
                                        msg: "Login Successful",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                      );

                                      Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (BuildContext context) => DashboardPage()));
                                    }else if(retVal == false){
                                      print('this isnt working');
                                    }

                                   }catch (e){
                                     setState(() {
                                        showSpinner = false;
                                      });
                                      Fluttertoast.showToast(
                                        msg: "Incorrect email and/or password",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                      );
                                     print(e.toString());
                                   }
                                 }
                                  //login(u);
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

                              // new SizedBox(
                              //   width: 20.0,
                              // ),
                              // new OutlineButton(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: 15.0, horizontal: 30.0),
                              //   borderSide: BorderSide(
                              //     color: Colors.grey[700],
                              //     style: BorderStyle.solid,
                              //     width: 1,
                              //   ),
                              //   textColor: Colors.white,
                              //   child: new Text("Sign Out"),
                              //   onPressed: () async{
                              //     await _services.signOut();
                                   
                              //   },
                              // ),
                              
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
      ),
    );
  }
}

  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }*/