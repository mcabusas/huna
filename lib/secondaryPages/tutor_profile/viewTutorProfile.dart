import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huna/modalPages/chat/messages_chat.dart';
import 'viewTutorProfile_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

var data, majors, languages, topics; 


class TutorProfilePage extends StatefulWidget {
  final dynamic tutorData;

  TutorProfilePage({Key key, this.tutorData});
  @override
  _TutorProfileState createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfilePage> {
  // Predefined List of Reasons for Reporting
  int _value = 1;
  ViewTutorProfileModel _model = new ViewTutorProfileModel();
  String chatRoomId;
  Map<String,dynamic> tutorData;
  bool retVal = false;
  bool showSpinner = false;
  Map<String, dynamic> data;



  @override
  void initState(){
    super.initState();
    print(widget.tutorData['tid']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red.shade800,
            ),
            onPressed: () async {
              try{
                retVal = await _model.addToFavorites(tutorData);
                if(retVal == true){
                  Fluttertoast.showToast(
                    msg: 'Tutor added to your favorites.',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white);
                }

              }catch (e) {
                print(e.toString());
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.forum),
            onPressed: () async {
              chatRoomId =  await _model.createChatRoom(tutorData);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(tutorData: tutorData, chatRoomId: chatRoomId, page: 1)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.error),
            onPressed: () {
              // Alert Dialog: Report Tutor
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

  Future<Map<String, dynamic>> initAwait() async {
    return await _model.getTutorData(widget.tutorData['tid']);
  }

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Widget retWidget;
    return FutureBuilder(
      future: initAwait(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          retWidget =  Container(child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.connectionState == ConnectionState.done){
          retWidget =  Stack(
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
                          '${widget.tutorData['firstName']} ${widget.tutorData['lastName']}',
                          //"${tutorInfo['user_firstName']} ${data[0]['user_lastName']}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Center(
                        child: Text(
                          'usename',
                          //'@${data[0]['username']}',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Average Rating: 5.0',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconTheme(
                                  data: IconThemeData(
                                    color: Colors.amber,
                                    size: 20
                                  ),
                                  child: StarDisplay(value: snapshot.data['rating'])
                                )
                              ],
                            ),
                          ),

                          // BASE PRICE
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 10.0),
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
                              ],
                            ),
                          ),
                          // BASE PRICE CARD
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
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
                                left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
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
                                          itemCount: majors == null ? 0 : majors.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return new Chip(
                                              label: Text(
                                                'dfas',
                                                //majors[index],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              backgroundColor: Colors.deepPurple.shade300,
                                              
                                          );
                                          }, 
                                          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200.0,
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 10.0,
                                            childAspectRatio: 4.0,
                                          ),
                                        ),

                                        GridView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(15),
                                          itemCount: languages== null ? 0 : languages.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return new Chip(
                                              label: Text(
                                                'dfasdf',
                                                //languages[index],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              backgroundColor: Colors.cyan.shade300,
                                              
                                          );
                                          }, 
                                          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200.0,
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 10.0,
                                            childAspectRatio: 4.0,
                                          ),
                                        ),

                                        GridView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(15),
                                          itemCount: topics== null ? 0 : topics.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return new Chip(
                                              label: Text(
                                                'topics[index]',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              backgroundColor: Colors.blue.shade300,
                                              
                                          );
                                          }, 
                                          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
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
      }
    );
  }
}

class StarDisplay extends StatelessWidget {
  final double value;
  StarDisplay({this.value = 0.0})
    :assert(value != null);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
         return Icon(
          index < value ? Icons.star : Icons.star_border
        );
      })
    );
  }
}
