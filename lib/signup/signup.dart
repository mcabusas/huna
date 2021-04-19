import 'dart:io';
import 'package:flutter/material.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import '../services/auth_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  File _image;
  //DateTime _dateTime;

  final _formKey = GlobalKey<FormState>();

  AuthServices _services = new AuthServices();

  Map<String, dynamic> data = {};
  bool progress = false;

  Future<Null> selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: null, initialDate: null, firstDate: null, lastDate: null);
  }

  Future imageFromGallery() async {
    try {
      final File image =
          await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });
    } catch (e) {
      print(e.toString());
    }
    //print(_productImage.toString());
    print(data);
  }

  Future imageFromCamera() async {
    try {
      final File image =
          await ImagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        _image = image;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        imageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
      body: ModalProgressHUD(
        inAsyncCall: progress,
        child: SafeArea(
          child: new ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                child: new Form(
                  key: _formKey,
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
                                icon: Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                ),
                                label: Text('Select Photo',
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.deepPurple.shade400, 
                                onPressed: () { 
                                  _showPicker(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        new TextFormField(
                          validator: (val) {
                            // ignore: unnecessary_statements
                            if (val.isEmpty) {
                              return 'Enter a username';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              data['username'] = val;
                            });
                          },
                          decoration: new InputDecoration(
                            labelText: "Username",
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        new TextFormField(
                          validator: (val) {
                            // ignore: unnecessary_statements
                            if (val.isEmpty) {
                              return 'Enter an email';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              data['email'] = val;
                            });
                          },
                          decoration: new InputDecoration(
                            labelText: "Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        new TextFormField(
                          validator: (val) {
                            // ignore: unnecessary_statements
                            if (val.isEmpty) {
                              return 'Enter a password';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              data['password'] = val;
                            });
                          },
                          decoration: new InputDecoration(
                            labelText: "Password",
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new TextFormField(
                          validator: (val) {
                            // ignore: unnecessary_statements
                            if (val.isEmpty) {
                              return 'Please confirm your password';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            data['confirmPassword'] = val;
                          },
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
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your first name';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['firstName'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "First Name",
                              ),
                              keyboardType: TextInputType.text,
                            ),

                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your last name';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['lastName'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "Last Name",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            // DATE PICKER
                            // Container(
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: <Widget>[
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 12.0),
                            //         child: Text(
                            //           'Date: ',
                            //           style: TextStyle(fontSize: 15),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 12.0),
                            //         child: Text(
                            //           _dateTime == null
                            //               ? ''
                            //               : DateFormat('MMMM d, yyyy')
                            //                   .format(_dateTime)
                            //                   .toString(),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 12.0),
                            //         child: RaisedButton.icon(
                            //           onPressed: () {
                            //             showDatePicker(
                            //               context: context,
                            //               initialDate: DateTime.now(),
                            //               firstDate: DateTime(1980),
                            //               lastDate: DateTime(2022),
                            //             ).then((date) {
                            //               setState(() {
                            //                 _dateTime = date;
                            //               });
                            //             });
                            //           },
                            //           icon: Icon(Icons.event),
                            //           label: Text('Date'),
                            //           color: Colors.grey.shade900,
                            //           textColor: Colors.white,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your home address';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['homeAddress'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "Home Address (Billing Address)",
                              ),
                              keyboardType: TextInputType.text,
                            ),

                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your the city where you reside';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['city'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "City",
                              ),
                              keyboardType: TextInputType.text,
                            ),

                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter the country where you reside';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['country'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "Country",
                              ),
                              keyboardType: TextInputType.text,
                            ),

                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your zip code';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['zipCode'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "Zip Code",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your contact number';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['contactNumber'] = val;
                                });
                              },
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
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your emergency contact first name';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['emergencyFirstName'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "First Name",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your emergency contact last name';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['emergencyLastName'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "Last Name",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your emergency contact number';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['emergencyContactNumber'] = val;
                                });
                              },
                              decoration: new InputDecoration(
                                labelText: "Contact Number",
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            new TextFormField(
                              validator: (val) {
                                // ignore: unnecessary_statements
                                if (val.isEmpty) {
                                  return 'Enter your emergency contact relation';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  data['emergencyRelation'] = val;
                                });
                              },
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
                                  "Submit",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (data['password'] ==
                                        data['confirmPassword']) {
                                      bool catcher = await _services.register(data, _image);

                                      if(catcher){

                                        print('success');
                                        bool retVal = await _services.login(data['email'], data['password']);

                                        if(retVal == true){

                                          setState(() {
                                            progress = true;
                                          });
                                          
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>DashboardPage()), (route) => false);
                                        }
                                      }else {
                                        print('sike');
                                      }
                                    }
                                  }
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
      ),
    );
  }
}
