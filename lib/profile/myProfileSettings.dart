import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:huna/login/login.dart';
import 'package:huna/profile/myProfile.dart';
import 'package:huna/profile/myProfileSettingsTags.dart';
import 'package:huna/profile/myProfileSettingsAcct.dart';
import 'package:huna/drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'myProfile_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

int _selectedIndex = 0;
int rate;
var jsonData;
TextEditingController currentpasswordController = new TextEditingController();
int tutorPage;
enum WidgetMaker { student, tutor }
SharedPreferences sp;

class MyProfileSettings extends StatefulWidget {
  @override
  _MyProfileSettingsState createState() => _MyProfileSettingsState();
}

class _MyProfileSettingsState extends State<MyProfileSettings> {
  String uid, tid;
  WidgetMaker selectedWidget = WidgetMaker.student;

  void initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
      tid = sp.getString('tid');
      print(sp.getString('country'));
    });
  }

  Widget getScreen() {
    switch (selectedWidget) {
      case WidgetMaker.student:
        return StudentProfileSettingsWidget();

      case WidgetMaker.tutor:
        return TutorProfileSettingsWidget();
    }

    return getScreen();
  }

  Widget bottomNavBar() {
    if (tid == null) {
      return null;
    } else {
      return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('Student'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_cafe),
              title: Text('Tutor'),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              if (index == 0) {
                setState(() {
                  selectedWidget = WidgetMaker.student;
                });
              } else if (index == 1) {
                setState(() {
                  selectedWidget = WidgetMaker.tutor;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAwait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfile()),
              );
            },
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                SizedBox(height: 20),
                // Profile Text
                Center(
                  child: Text(
                    '${sp.getString('firstName')} ${sp.getString('lastName')}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                // Center(
                //   child: Text(
                //     'u.username',
                //     style: TextStyle(color: Colors.white70),
                //   ),
                // ),
                SizedBox(height: 20),
                // Location
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 15,
                      ),
                      Text(
                        "${sp.getString('city')}, ${sp.getString('country')}",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // White Body Contents
              ],
            ),
          ),
        ),
        getScreen(),
      ]),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

class StudentProfileSettingsWidget extends StatefulWidget {
  @override
  _StudentProfileSettingsWidgetState createState() =>
      _StudentProfileSettingsWidgetState();
}

class _StudentProfileSettingsWidgetState
    extends State<StudentProfileSettingsWidget> {
  void initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      // uid = sp.getString('uid');
      // tid = sp.getString('tid');
      print(sp.getString('country'));
    });
  }

  Future createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Type your current password for confirmation'),
            content: TextFormField(
              controller: currentpasswordController,
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.grey.shade900,
                textColor: Colors.white,
                onPressed: () {
                  //updateProfile();
                },
                child: Text('Submit'),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAwait();
  }

  //  updateProfile() async {
  //   var data = {
  //     'id': u.id,
  //     'email': emailController.text,
  //     'currentPassword': currentpasswordController.text,
  //     'password': passwordController.text,
  //     'confirm': confirmPasswordController.text,
  //     'homeAddress': homeAddressController.text,
  //     'city': cityController.text,
  //     'country': countryController.text,
  //     'zipCode': zipCodeController.text,
  //     'contactNumber': contactNumberController.text,
  //     'emergencyFirst': emergencyFirstController.text,
  //     'emergencyLast': emergencyLastController.text,
  //     'emergencyNumber': emergencyNumberController.text,
  //     'emergencyRelation': currentMenuItem,
  //     'settingsValue': settingsValue.toString(),
  //     'selectedIndex': _selectedIndex.toString(),
  //     };

  //     final response = await http.post("https://hunacapstone.com/database_files/updateProfile.php", body: data);

  //     if(response.statusCode == 200){
  //       setState(() {
  //         jsonData = jsonDecode(response.body);
  //       });
  //       print(jsonData);

  //       if(jsonData['value'] == 1){
  //         //Navigator.pop(context);
  //         print(jsonData.toString());
  //       }else if(jsonData['value'] == 0){
  //         print('the password is incorrect; please try again');
  //       }
  //     }
  // }

  // void initState(){
  //   super.initState();
  //   _selectedIndex = 0;
  //   print('this is my selectedindex: $_selectedIndex');
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.only(top: 150),
              child: ListView(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
                    child: new Form(
                      child: Column(
                        children: <Widget>[
                          new ExpansionTile(
                            onExpansionChanged: (bool val) {
                              setState(() {
                                settingsValue = 1;
                              });
                            },
                            title: Text('Account Details'),
                            children: <Widget>[
                              AccountDetails(),
                            ],
                            trailing: IgnorePointer(
                              child: Icon(Icons.edit),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ExpansionTile(
                            onExpansionChanged: (bool val) {
                              setState(() {
                                settingsValue = 2;
                              });
                            },
                            title: Text('Personal Details'),
                            children: <Widget>[
                              PersonalDetails(
                                  homeAddress: sp.getString('homeAddress'),
                                  city: sp.getString('city'),
                                  country: sp.getString('country'),
                                  zipCode: sp.getString('zipCode'),
                                  contactNumber: sp.getString('contactNumber'),
                                  uid: sp.getString('uid')),
                            ],
                            trailing: IgnorePointer(
                              child: Icon(Icons.edit),
                            ),
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          ExpansionTile(
                            onExpansionChanged: (bool val) {
                              setState(() {
                                settingsValue = 3;
                              });
                            },
                            title: Text('In Case of Emergency'),
                            children: <Widget>[
                              EmergencyDetails(
                                  emergencyFirstName:
                                      sp.getString('emergencyFirstName'),
                                  emergencyLastName:
                                      sp.getString('emergencyLastName'),
                                  emergencyRelation:
                                      sp.getString('emergencyRelation'),
                                  emergencyContactNumber:
                                      sp.getString('emergencyContactNumber'),
                                  uid: sp.getString('uid'))
                            ],
                            trailing: IgnorePointer(
                              child: Icon(Icons.edit),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   child: new MaterialButton(
                          //     color: Colors.grey.shade900,
                          //     textColor: Colors.white,
                          //     child: new Text(
                          //       "Save",
                          //       style: TextStyle(fontSize: 15.0),
                          //     ),
                          //     onPressed: () {
                          //       createAlertDialog(context);

                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    ]);
  }
}

class TutorProfileSettingsWidget extends StatefulWidget {
  @override
  _TutorProfileSettingsWidgetState createState() =>
      _TutorProfileSettingsWidgetState();
}

class _TutorProfileSettingsWidgetState
    extends State<TutorProfileSettingsWidget> {
  MyProfileModel _model = new MyProfileModel();
  String uid, tid;
  bool showSpinner = false;
  final _key = new GlobalKey<FormState>();
  void initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
      tid = sp.getString('tid');
      print(sp.getString('rate'));
    });
  }

  void initState() {
    super.initState();
    tutorPage = 1;
    initAwait();
  }

  List<String> majors, languages, topics;

  @override
  Widget build(BuildContext context) {
    Widget tagsWidget;
    Widget rateWidget;

    return StreamBuilder(
      stream: _model.getTutorRateAndTags(uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          tagsWidget = Center(child: CircularProgressIndicator());
          rateWidget = Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          var tutorData = snapshot.data.docs[0];
          print(tutorData['majors']);

          rateWidget = Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(20),
                title: Text(
                  tutorData['rate'] + '.00',
                  style: TextStyle(fontSize: 30),
                ),
                subtitle: Text("Per Hour"),
              ),
            ),
          );

          tagsWidget = SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 5.0,
                      children: <Widget>[
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15),
                          itemCount: tutorData['majors'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Chip(
                              label: Text(
                                tutorData['majors'][index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.deepPurple.shade300,
                            );
                          },
                          gridDelegate:
                              new SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 4.0,
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15),
                          itemCount: languages == null ? 0 : languages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Chip(
                              label: Text(
                                languages[index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.cyan.shade300,
                            );
                          },
                          gridDelegate:
                              new SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 4.0,
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(15),
                          itemCount: tutorData['topics'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Chip(
                              label: Text(
                                tutorData['topics'][index],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.blue.shade300,
                            );
                          },
                          gridDelegate:
                              new SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 4.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.only(top: 150),
                child: ListView(
                  children: <Widget>[
                    // BASE PRICE
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Base Price
                          Text(
                            'Base Price',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Alert Dialog: Edit Base Price
                              String newRate;
                              bool retVal;
                              showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text("Edit Base Price"),
                                  content: Form(
                                    key: _key,
                                    child: TextFormField(
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return 'Please input value for new rate';
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {
                                        newRate = val;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Base Price',
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  elevation: 24.0,
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () async {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');
                                        print('cancel');
                                      }, // Navigator.pop(context) closes the entire page.
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.cyan),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        // Update Base Price
                                        print(tid);
                                        if (_key.currentState.validate()) {
                                          setState(() {
                                            showSpinner = true;
                                          });

                                          try {
                                            retVal = await _model.editRate(
                                                tid, newRate);
                                            if (retVal == true) {
                                              setState(() {
                                                showSpinner = false;
                                              });

                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop('dialog');

                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Your rate has been editted successfully.",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIos: 1,
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          } catch (e) {
                                            setState(() {
                                              showSpinner = false;
                                            });

                                            Fluttertoast.showToast(
                                                msg:
                                                    "Not able to update your rate, please try again later",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIos: 1,
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            print(e.toString());
                                          }
                                        }
                                      },
                                      child: Text(
                                        "Save",
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // BASE PRICE CARD
                    rateWidget,
                    // CHIPS LABEL
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //Topics, etc.
                          Text(
                            'Topics, Skills and Languages',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TagsPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // CARD OF CHIPS
                    tagsWidget,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
