import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/modalPages/messages_chat.dart';



class StudentProfilePage extends StatefulWidget {
  final studentData;

  const StudentProfilePage({Key key, this.studentData});
  
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfilePage> {
  // Predefined List of Reasons for Reporting
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Bookings()),
            );
          },
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.forum),
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );*/
              print(widget.studentData);
            },
          ),
          IconButton(
            icon: Icon(Icons.error),
            onPressed: () {
              // Alert Dialog: Report Student
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text("Report Student"),
                  content: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Select a reason: '),
                        DropdownButtonFormField(
                          hint: Text("Select Reason"),
                          value: _value,
                          isDense: false,
                          isExpanded: true,
                          items: <DropdownMenuItem>[
                            DropdownMenuItem(
                              child: Text('Inappropriate behavior'),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text('Profile contains offensive content'),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text('User send spam messages'),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text('Fake Profile'),
                              value: 4,
                            ),
                            DropdownMenuItem(
                              child: Text('Deceased Profile'),
                              value: 5,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                  'Charged an extra fee outside of booking'),
                              value: 6,
                            ),
                            DropdownMenuItem(
                              child: Text('Others'),
                              value: 7,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        Text('Additional comments: '),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Comments',
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 24.0,
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(
                              'dialog'), // Navigator.pop(context) closes the entire page.
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        // Update Base Price
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StudentProfileWidget(studentData: widget.studentData),
    );
  }
}

class StudentProfileWidget extends StatelessWidget {
  final studentData;

  const StudentProfileWidget({Key key, this.studentData});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
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
                  backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                ),
                SizedBox(height: 20),
                // Profile Text
                Center(
                  child: Text(
                    studentData['user_firstName'] + " " + studentData['user_lastName'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Center(
                  child: Text(
                    '@' + studentData['username'],
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
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
                        ' Cebu City, Philippines',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // White Body Contents
        Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.only(top: 150),
                child: ListView(
                  children: <Widget>[
                    // RATINGS
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 40.0),
                      child: Center(
                        child: Text(
                          '4.0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20),

                    // STARS
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star,
                              size: 30, color: Colors.amber.shade400),
                          Icon(Icons.star,
                              size: 30, color: Colors.amber.shade400),
                          Icon(Icons.star,
                              size: 30, color: Colors.amber.shade400),
                          Icon(Icons.star,
                              size: 30, color: Colors.amber.shade400),
                          Icon(
                            Icons.star,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),

                    // RATINGS
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 10.0),
                      child: Center(
                        child: Text(
                          'Average Rating according to 15 tutors.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
      ],
    );
  }
}
