import 'dart:io';
import 'package:flutter/material.dart';
import 'package:huna/login.dart';
import 'package:huna/modalPages/verifyAccount.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(SignUp());

class SignUp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {

  Future<Null> selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: null, initialDate: null, firstDate: null, lastDate: null
      );
  }


  File _image;
  DateTime _dateTime;



  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController homeAddressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();
  TextEditingController contactNumberController = new TextEditingController();
  TextEditingController emergencyFirstController = new TextEditingController();
  TextEditingController emergencyLastController = new TextEditingController();
  TextEditingController emergencyNumberController = new TextEditingController();
  TextEditingController emergencyRelationController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();

  
  var image;
   

  Future getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  void register() async{

    var data = {
      'username': usernameController.text, 
      'email': emailController.text,
      'password': passwordController.text,
      'confirm': confirmPasswordController.text,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'homeAddress': homeAddressController.text,
      'city': cityController.text,
      'country': countryController.text,
      'zipCode': zipCodeController.text,
      'contactNumber': contactNumberController.text,
      'emergencyFirst': emergencyFirstController.text,
      'emergencyLast': emergencyLastController.text,
      'emergencyNumber': emergencyNumberController.text,
      'emergencyRelation': emergencyRelationController.text,
      'date': new DateFormat("yyyy-MM-dd").format(_dateTime)
      };

    final response = await http.post("https://hunacapstone.com//database_files/register.php", body: data);

    var ret = jsonDecode(response.body);

    print(ret.toString());

  }

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
        title: Text('Sign Up'),
      ),
      body: SafeArea(
        child: new ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: new Form(
                child: new Theme(
                  data: new ThemeData(
                    brightness: Brightness.light,
                    primarySwatch: Colors.grey,
                    inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: new TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        // padding: EdgeInsets.only(top: 30.0),
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: _image == null
                              ? AssetImage('assets/images/default.png')
                              : FileImage(_image),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton.icon(
                              onPressed: getImage,
                              icon: Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                              label: Text('Select Photo',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.deepPurple.shade400,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      new TextFormField(
                        controller: usernameController,
                        decoration: new InputDecoration(                          
                          labelText: "Username",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      new TextFormField(
                        controller: emailController,
                        decoration: new InputDecoration(
                          labelText: "Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      new TextFormField(
                        controller: passwordController,
                        decoration: new InputDecoration(
                          labelText: "Password",
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      new TextFormField(
                        controller: confirmPasswordController,
                        decoration: new InputDecoration(
                          labelText: "Confirm Password",
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
                            child: new Text(
                              "PERSONAL INFORMATION",
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          new TextFormField(
                            controller: firstNameController,
                            decoration: new InputDecoration(
                              labelText: "First Name",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                            controller: lastNameController,
                            decoration: new InputDecoration(
                              labelText: "Last Name",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          // DATE PICKER
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    'Date: ',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    _dateTime == null
                                        ? ''
                                        : DateFormat('MMMM d, yyyy')
                                            .format(_dateTime)
                                            .toString(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: RaisedButton.icon(
                                    onPressed: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1980),
                                        lastDate: DateTime(2022),
                                      ).then((date) {
                                        setState(() {
                                          _dateTime = date;
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.event),
                                    label: Text('Date'),
                                    color: Colors.grey.shade900,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new TextFormField(
                            controller: homeAddressController,
                            decoration: new InputDecoration(
                              labelText: "Home Address (Billing Address)",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                            controller: cityController,
                            decoration: new InputDecoration(
                              labelText: "City",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                            controller: countryController,
                            decoration: new InputDecoration(
                              labelText: "Country",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                            controller: zipCodeController,
                            decoration: new InputDecoration(
                              labelText: "Zip Code",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                            controller: contactNumberController,
                            decoration: new InputDecoration(
                              labelText: "Contact Number",
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
                            child: new Text(
                              "IN CASE OF EMERGENCY",
                              style: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          new TextFormField(
                            controller: emergencyFirstController,
                            decoration: new InputDecoration(
                              labelText: "First Name",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                            controller: emergencyLastController,
                            decoration: new InputDecoration(
                              labelText: "Last Name",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                            controller: emergencyNumberController,
                            decoration: new InputDecoration(
                              labelText: "Contact Number",
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          new TextFormField(
                            controller: emergencyRelationController,
                            decoration: new InputDecoration(
                              labelText: "Relation",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 60.0),
                            child: new MaterialButton(
                              // padding: EdgeInsets.symmetric(vertical: 15.0),
                              color: Colors.grey.shade900,
                              textColor: Colors.white,
                              child: new Text(
                                "Next",
                                style: TextStyle(fontSize: 15.0),
                              ),
                              onPressed: () {
                                register();
                                /*Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => VerifyAccount()),
                                );*/
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
