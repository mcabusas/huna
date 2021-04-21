import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'myProfile_model.dart';

String currentMenuItem = "Parent";
int settingsValue;
final _formKey = GlobalKey<FormState>();
MyProfileModel _model = new MyProfileModel();
bool retVal;

class EmergencyDetails extends StatelessWidget {
  final uid;
  EmergencyDetails({this.uid});
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'emergencyFirstName': '',
      'emergencyLastName': '',
      'emergencyContactNumber': '',
      'emergencyRelation': ''
    };

    // void getDropDownItem() {
    //   setState(() {
    //     data['emergencyRelation'] = currentMenuItem;
    //     print(data['emergencyRelation']);
    //   });
    // }

    return Column(
      children: [
        StreamBuilder(
          stream: _model.getSettingsData(uid),
          builder: (context, snapshot) {
            Widget form = Container(height: 0, width: 0);
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('waiting...');
              form = CircularProgressIndicator();
            }
            if (snapshot.connectionState == ConnectionState.active) {
              data = {
                'emergencyFirstName': snapshot.data.docs[0]
                    ['emergencyFirstName'],
                'emergencyLastName': snapshot.data.docs[0]['emergencyLastName'],
                'emergencyContactNumber': snapshot.data.docs[0]
                    ['emergencyContactNumber'],
              };
              form = Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      // Account Details Input

                      new TextFormField(
                        initialValue: snapshot.data.docs[0]
                            ['emergencyFirstName'],
                        validator: (val) {
                          if (val.isEmpty) {
                            return "First name can't be empty";
                          }

                          return null;
                        },
                        onChanged: (val) {
                          data['emergencyFirstName'] = val;
                        },
                        decoration: new InputDecoration(
                          labelText: "First Name",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      new TextFormField(
                        initialValue: snapshot.data.docs[0]
                            ['emergencyLastName'],
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Last name can't be empty";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          data['emergencyLastName'] = val;
                        },
                        decoration: new InputDecoration(
                          labelText: "Last Name",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      new TextFormField(
                        initialValue: snapshot.data.docs[0]
                            ['emergencyContactNumber'],
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Contact number can't be empty";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          data['emergencyContactNumber'] = val;
                        },
                        decoration: new InputDecoration(
                          labelText: "Contact Number",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              //print(snapshot.data.docs[0]['emergencyFirstName']);
            }

            return form;
          },
        ),
        DropdownButton<String>(
          value: 'Parent',
          hint: Text(currentMenuItem.toString()),
          items: <String>['Parent', 'Sibling', 'Guardian'].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) {
            currentMenuItem = value;
            print(currentMenuItem);
            // setState(() {
            //   currentMenuItem = value;
            // });
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: new MaterialButton(
            color: Colors.grey.shade900,
            textColor: Colors.white,
            child: new Text(
              "Save",
              style: TextStyle(fontSize: 15.0),
            ),
            onPressed: () async {
              //getDropDownItem();
              if (_formKey.currentState.validate()) {
                try {
                  retVal = await _model.editStudentEmergencyContact(
                      uid, data);
                  if (retVal == true) {
                    Fluttertoast.showToast(
                        msg: "Emergency Details was updated successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } catch (e) {
                  print(e.toString());
                  Fluttertoast.showToast(
                      msg: "Error updating data",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              }

              //createAlertDialog(context);
            },
          ),
        ),
      ],
    );
  
  }
}

class PersonalDetails extends StatefulWidget {
  final uid;

  PersonalDetails({this.uid});
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _model.getSettingsData(widget.uid),
      builder: (context, snapshot) {
        Widget form = Container(height: 0, width: 0);
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('waiting...');
          form = CircularProgressIndicator();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic> data = {
            'homeAddress': snapshot.data.docs[0]['homeAddress'],
            'city': snapshot.data.docs[0]['city'],
            'country': snapshot.data.docs[0]['country'],
            'zipCode': snapshot.data.docs[0]['zipCode'],
            'contactNumber': snapshot.data.docs[0]['contactNumber'],
          };
          form = Form(
            key: _formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  // Account Details Input

                  new TextFormField(
                    initialValue: snapshot.data.docs[0]['homeAddress'],
                    onChanged: (val) {
                      data['homeAddress'] = val;
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Home Address can't be empty";
                      }
                      return null;
                    },
                    //controller: homeAddressController,
                    decoration: new InputDecoration(
                      labelText: "Home Address (Billing Address)",
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  new TextFormField(
                    initialValue: snapshot.data.docs[0]['city'],
                    onChanged: (val) {
                      data['city'] = val;
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return "City can't be empty";
                      }
                      return null;
                    },
                    //controller: cityController,
                    decoration: new InputDecoration(
                      labelText: "City",
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  new TextFormField(
                    initialValue: snapshot.data.docs[0]['country'],
                    //controller: countryController,
                    onChanged: (val) {
                      data['country'] = val;
                    },
                    decoration: new InputDecoration(
                      labelText: "Country",
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  new TextFormField(
                    initialValue: snapshot.data.docs[0]['zipCode'],
                    onChanged: (val) {
                      data['zipCode'] = val;
                    },
                    //controller: zipCodeController,
                    decoration: new InputDecoration(
                      labelText: "Zip Code",
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  new TextFormField(
                    initialValue: snapshot.data.docs[0]['contactNumber'],
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Contact number can't be empty";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      data['contactNumber'] = val;
                    },
                    //controller: contactNumberController,
                    decoration: new InputDecoration(
                      labelText: "Contact Number",
                    ),
                    keyboardType: TextInputType.text,
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: new MaterialButton(
                      color: Colors.grey.shade900,
                      textColor: Colors.white,
                      child: new Text(
                        "Save",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          try {
                            retVal = await _model.editStudentPersonalDetails(
                                widget.uid, data);
                            if (retVal == true) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Personal Details was updated successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } catch (e) {
                            print(e.toString());
                            Fluttertoast.showToast(
                                msg: "Error updating data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }

                        //createAlertDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          //print(snapshot.data.docs[0]['emergencyFirstName']);
        }

        return form;
      },
    );
  }
}
