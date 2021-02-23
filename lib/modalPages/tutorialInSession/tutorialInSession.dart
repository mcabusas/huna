import 'package:flutter/material.dart';
import 'package:huna/modalPages/bookings_onTheDay.dart';
import 'package:huna/modalPages/onTheDay_answerPostTest.dart';
import 'package:huna/modalPages/onTheDay_sos.dart';
import 'tutorialInSession_modal.dart';
import '../tutorialComplete/tutorial_complete.dart';

// void main() => runApp(TutorialInSession());

// class TutorialInSession extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'HUNA',
//       theme: ThemeData(
//         primaryColor: Colors.grey.shade900,
//         primarySwatch: Colors.blueGrey,
//       ),
//       home: TutorialInSessionPage(),
//     );
//   }
// }

class TutorialInSession extends StatefulWidget {
  final data;
  TutorialInSession({this.data});
  @override
  _TutorialInSessionState createState() => _TutorialInSessionState();
}

class _TutorialInSessionState extends State<TutorialInSession> {

  TutorialInSessionModal _model = new TutorialInSessionModal();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(widget.studentData['bookingData']['student_firstName']);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => OnTheDay()),
              // );
            }),
        title: Text('In Session'),
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bgk.jpg'), 
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.85), 
                    BlendMode.darken,
                    ),                    
                  fit: BoxFit.fill,
                  ),
              ),
        ),
        SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(child: SizedBox(height: 80)),
                    Center(
                      child: Text(
                        "Tutorial \n is in session.",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(child: SizedBox(height: 200)),
                    // BUTTONS
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton.icon(
                        onPressed: () async{
                          _model.endTutorial(widget.data['bookingId']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TutorialComplete(data: widget.data, flag: 0)),
                            );
                        },
                        icon: Icon(Icons.assignment),
                        label: Text('End Tutorial'),
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SOS()),
                            );
                        },
                        icon: Icon(Icons.assignment),
                        label: Text('SOS'),
                        color: Colors.black,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
