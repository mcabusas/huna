
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();
TextEditingController confirmPasswordController = new TextEditingController();
TextEditingController homeAddressController = new TextEditingController();
TextEditingController cityController = new TextEditingController();
TextEditingController countryController = new TextEditingController();
TextEditingController zipCodeController = new TextEditingController();
TextEditingController contactNumberController = new TextEditingController();
TextEditingController emergencyFirstController = new TextEditingController();
TextEditingController emergencyLastController = new TextEditingController();
TextEditingController emergencyNumberController = new TextEditingController();
String currentMenuItem = "Parent";
int settingsValue;

class EmergencyDetails extends StatefulWidget {
  @override
  _EmergencyDetailsState createState() => _EmergencyDetailsState();
}

class _EmergencyDetailsState extends State<EmergencyDetails> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
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
        keyboardType: TextInputType.text,
      ),
      DropdownButton<String>(
        hint: Text('Relation'),
        items: ['Parent', 'Sibling', 'Guardian'].map((String dropDownStringItem){
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: (Text(dropDownStringItem)),
                                );
        }).toList(), 
        onChanged: (String value) {
          setState(() {
            currentMenuItem = value;
            print(currentMenuItem);
          });
        },
        value: currentMenuItem
                              
      ),
      
      ],),
    );
  }
}

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
                              // Account Details Input
                              
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
        keyboardType: TextInputType.text,
      ),
      ],),
    );
  }
}

class AccountDetails extends StatefulWidget{
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(children: <Widget>[Row(
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
        ),new TextFormField(
        controller: emailController,
        decoration: new InputDecoration(
          labelText: "Email",
        ),
        keyboardType: TextInputType.text,
      ),new TextFormField(
        controller: passwordController,
        decoration: new InputDecoration(
          labelText: "New Password",
        ),
        keyboardType: TextInputType.text,
      ),new TextFormField(
        controller: confirmPasswordController,
        decoration: new InputDecoration(
          labelText: "Confirm Password",
        ),
        keyboardType: TextInputType.text,
      ),
      
      ],),
    );
  }
}