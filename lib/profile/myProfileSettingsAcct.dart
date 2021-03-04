import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'myProfile_model.dart';

String currentMenuItem = "Parent";
int settingsValue;
final _formKey = GlobalKey<FormState>();
MyProfileModel _model = new MyProfileModel();
bool retVal;

class EmergencyDetails extends StatefulWidget {
  final emergencyFirstName;
  final emergencyLastName;
  final emergencyContactNumber;
  final emergencyRelation;
  final uid;

  EmergencyDetails(
      {this.emergencyFirstName,
      this.emergencyContactNumber,
      this.emergencyLastName,
      this.emergencyRelation,
      this.uid});
  @override
  _EmergencyDetailsState createState() => _EmergencyDetailsState();
}

class _EmergencyDetailsState extends State<EmergencyDetails> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'emergencyFirstName': widget.emergencyFirstName,
      'emergencyLastName': widget.emergencyLastName,
      'emergencyContactNumber': widget.emergencyContactNumber,
      'emergencyRelation': widget.emergencyRelation
    };

    void getDropDownItem() {
      setState(() {
        data['emergencyRelation'] = currentMenuItem;
      });
    }

    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'In Case of Emergency',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
            // Account Details Input

            new TextFormField(
              initialValue: data['emergencyFirstName'],
              onChanged: (val) {
                data['emergencyFirstName'] = val;
              },
              validator: (val) {
                if (val.isEmpty) {
                  return "First name can't be empty";
                }

                return null;
              },
              decoration: new InputDecoration(
                labelText: "First Name",
              ),
              keyboardType: TextInputType.text,
            ),
            new TextFormField(
              initialValue: data['emergencyLastName'],
              onChanged: (val) {
                data['emergencyLastName'] = val;
              },
              validator: (val) {
                if (val.isEmpty) {
                  return "Last name can't be empty";
                }
                return null;
              },
              decoration: new InputDecoration(
                labelText: "Last Name",
              ),
              keyboardType: TextInputType.text,
            ),
            new TextFormField(
              initialValue: data['emergencyContactNumber'],
              onChanged: (val) {
                data['emergencyContactNumber'] = val;
              },
              validator: (val) {
                if (val.isEmpty) {
                  return "Contact number can't be empty";
                }
                return null;
              },
              decoration: new InputDecoration(
                labelText: "Contact Number",
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
                hint: Text('Relation'),
                items: ['Parent', 'Sibling', 'Guardian']
                    .map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: (Text(dropDownStringItem)),
                  );
                }).toList(),
                onChanged: (String value) {
                  setState(() {
                    currentMenuItem = value;
                  });
                },
                value: currentMenuItem),

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
                  getDropDownItem();
                  print(data['emergencyRelation']);
                  if (_formKey.currentState.validate()) {
                    try {
                      retVal = await _model.editStudentEmergencyContant(
                          widget.uid, data);
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
        ),
      ),
    );
  }
}

class PersonalDetails extends StatefulWidget {
  final homeAddress;
  final city;
  final country;
  final zipCode;
  final contactNumber;
  final uid;

  PersonalDetails(
      {this.homeAddress,
      this.city,
      this.country,
      this.zipCode,
      this.contactNumber,
      this.uid});
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  // Future createAlertDialog(BuildContext context){
  //   return showDialog(context: context, builder: (context){
  //     return AlertDialog(
  //       title: Text('Type your current password for confirmation'),
  //       content: TextFormField(
  //         //controller: currentpasswordController,
  //       ),
  //       actions: <Widget>[
  //         MaterialButton(
  //           color: Colors.grey.shade900,
  //           textColor: Colors.white,
  //           onPressed: (){
  //             //updateProfile();
  //           },
  //           child: Text('Submit'),
  //           )
  //       ],
  //     );
  //   });

  // }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {
      'homeAddress': widget.homeAddress,
      'city': widget.city,
      'country': widget.country,
      'zipCode': widget.zipCode,
      'contactNumber': widget.contactNumber,
    };

    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            // Account Details Input

            new TextFormField(
              initialValue: data['homeAddress'],
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
              initialValue: data['city'],
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
              initialValue: data['country'],
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
              initialValue: data['zipCode'],
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
              initialValue: data['contactNumber'],
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
                            msg: "Personal Details was updated successfully",
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
}

class AccountDetails extends StatefulWidget {
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Account Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
            ],
          ),
          //   new TextFormField(
          //   controller: emailController,
          //   decoration: new InputDecoration(
          //     labelText: "Email",
          //   ),
          //   keyboardType: TextInputType.text,
          // ),
          new TextFormField(
            decoration: new InputDecoration(
              labelText: "New Password",
            ),
            keyboardType: TextInputType.text,
          ),
          new TextFormField(
            decoration: new InputDecoration(
              labelText: "Confirm Password",
            ),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
