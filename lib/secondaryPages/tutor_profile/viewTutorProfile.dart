import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huna/modalPages/chat/messages_chat.dart';
import 'viewTutorProfile_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../components/profilePicture.dart';
import 'package:shared_preferences/shared_preferences.dart';

var data, majors, languages, topics;

class TutorProfilePage extends StatefulWidget {
  final dynamic tutorData;

  TutorProfilePage({Key key, this.tutorData});
  @override
  _TutorProfileState createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfilePage> {
  // Predefined List of Reasons for Reporting
  String _value = 'Inappripiate behavior';
  ViewTutorProfileModel _model = new ViewTutorProfileModel();
  String chatRoomId, userId = '';
  Map<String, dynamic> tutorData;
  bool retVal = false;
  bool showSpinner = false;
  bool favoriteChecker = false;
  SharedPreferences sp;
  TextEditingController controller = new TextEditingController();
  Color favoriteIconColor = Colors.white;

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      userId = sp.getString('uid');
      data = {
        'reason': _value,
        'comment': '',
        'uid': userId,
        'tid': widget.tutorData['tid']
      };
    });
    favoriteChecker =
        await _model.checkFavorite(widget.tutorData['tid'], userId);
    if (favoriteChecker == true) {
      setState(() {
        favoriteIconColor = Colors.red;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initAwait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite, color: favoriteIconColor),
            onPressed: () async {
              try {
                retVal = await _model.addToFavorites(widget.tutorData);
                if (retVal == true) {
                  Fluttertoast.showToast(
                      msg: 'Tutor added to your favorites.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white);
                  setState(() {
                    favoriteIconColor = Colors.red;
                  });
                } else {
                  Fluttertoast.showToast(
                      msg: 'Tutor is already part of your favorites',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white);
                }
              } catch (e) {
                print(e.toString());
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.forum),
            onPressed: () async {
              print(widget.tutorData['tid']);
              chatRoomId = await _model.createChatRoom(widget.tutorData);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                        tutorData: widget.tutorData,
                        chatRoomId: chatRoomId,
                        page: 1)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.error),
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text("Report Tutor"),
                  content: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Select a reason: '),
                        DropdownButtonFormField<String>(
                          value: 'Inappropriate behavior',
                          isDense: false,
                          isExpanded: true,
                          //hint: Text(_value.toString()),
                          items: <String>[
                            'Inappropriate behavior',
                            'Profile contains offensive content',
                            'User send spam messages',
                            'Fake Profile',
                            'Deceased Profile',
                            'Charged an extra fee outside of booking',
                            'Others'
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _value = value;
                            print(_value);
                            data['reason'] = _value;
                          },
                        ),
                        SizedBox(height: 20.0),
                        Text('Additional comments: '),
                        TextField(
                          controller: controller,
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
                      onPressed: () async {
                        if (controller.text.isNotEmpty) {
                          setState(() {
                            data['comment'] = controller.text;
                          });
                        }
                        try {
                          bool catcher = await _model.createReport(data);
                          if (catcher == true) {
                            Fluttertoast.showToast(
                                msg: "Tutor has been reported, thank you.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          } else {
                            Fluttertoast.showToast(
                                msg: "Error reporting tutor, please try again.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } catch (e) {
                          print(e.toString());
                        }
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
      body: TutorProfileWidget(tutorData: widget.tutorData),
    );
  }
}

class TutorProfileWidget extends StatefulWidget {
  final tutorData;

  const TutorProfileWidget({Key key, this.tutorData});

  @override
  _TutorProfileWidgetState createState() => _TutorProfileWidgetState();
}

class _TutorProfileWidgetState extends State<TutorProfileWidget> {
  bool retVal;
  bool showSpinner = false;
  ViewTutorProfileModel _model = new ViewTutorProfileModel();

  Future<double> initAwait() async {
    return await _model.getTutorData(widget.tutorData['uid']);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget retWidget;
    return FutureBuilder(
        future: initAwait(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            retWidget =
                Container(child: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print('done');
            retWidget = Stack(
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
                        FutureBuilder(
                            future: _model.getPicture(widget.tutorData['uid']),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              Widget picture;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                picture = Container(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                picture = ClipOval(
                                    child: ProfilePicture(
                                        url: snapshot.data,
                                        width: 100,
                                        height: 100));
                              }

                              return picture;
                            }),

                        // CircleAvatar(
                        //   radius: 40,
                        //   backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                        // ),
                        SizedBox(height: 20),
                        // Profile Text
                        Center(
                          child: Text(
                            '${widget.tutorData['firstName']} ${widget.tutorData['lastName']}',
                            //"${tutorInfo['user_firstName']} ${data[0]['user_lastName']}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        // Center(
                        //   child: Text(
                        //     'usename',
                        //     //'@${data[0]['username']}',
                        //     style: TextStyle(color: Colors.white70),
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        // Location
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(left: 25.0, right: 25.0),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Icon(
                        //         Icons.location_on,
                        //         color: Colors.white,
                        //         size: 15,
                        //       ),
                        //       // Text(
                        //       //   '${snapshot.data['city']}, ${snapshot.data['country']}',
                        //       //   style: TextStyle(
                        //       //       color: Colors.white, fontSize: 12),
                        //       // ),
                        //     ],
                        //   ),
                        // ),
                        // White Body Contents
                      ],
                    ),
                  ),
                ),
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
                                  left: 25.0, right: 25.0, top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Average Rating: ${snapshot.data}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconTheme(
                                      data: IconThemeData(
                                          color: Colors.amber, size: 20),
                                      child: StarDisplay(value: snapshot.data))
                                ],
                              ),
                            ),

                            // BASE PRICE
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // Base Price
                                  Text(
                                    'Base Price',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // BASE PRICE CARD
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(20),
                                  title: Text(
                                    "P ${widget.tutorData['rate']}.00",
                                    //"P ${data[0]['rate']}.00",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  subtitle: Text("Per Hour"),
                                ),
                              ),
                            ),
                            // CHIPS LABEL
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //Topics, etc.
                                  Text(
                                    'Topics, Skills and Languages',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // CARD OF CHIPS
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, bottom: 10.0),
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
                                          itemCount: widget.tutorData['majors']
                                                      .length ==
                                                  null
                                              ? 0
                                              : widget
                                                  .tutorData['majors'].length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return new Chip(
                                              label: Text(
                                                widget.tutorData['majors']
                                                    [index],
                                                //majors[index],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              backgroundColor:
                                                  Colors.deepPurple.shade300,
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
                                          itemCount: widget
                                                      .tutorData['languages']
                                                      .length ==
                                                  null
                                              ? 0
                                              : widget.tutorData['languages']
                                                  .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return new Chip(
                                              label: Text(
                                                widget.tutorData['languages']
                                                    [index],
                                                //languages[index],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              backgroundColor:
                                                  Colors.cyan.shade300,
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
                                          itemCount: widget.tutorData['topics']
                                                      .length ==
                                                  null
                                              ? 0
                                              : widget
                                                  .tutorData['topics'].length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return new Chip(
                                              label: Text(
                                                widget.tutorData['topics']
                                                    [index],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              backgroundColor:
                                                  Colors.blue.shade300,
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return retWidget;
        });
  }
}

class StarDisplay extends StatelessWidget {
  final double value;
  StarDisplay({this.value = 0.0}) : assert(value != null);
  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(5, (index) {
      return Icon(index < value ? Icons.star : Icons.star_border);
    }));
  }
}
