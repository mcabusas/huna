import 'package:flutter/material.dart';
import 'package:huna/modalPages/bookings_onTheDay.dart';
import 'package:huna/modalPages/onTheDay_answerPostTest.dart';
import 'package:huna/modalPages/onTheDay_sos.dart';

void main() => runApp(TutorialInSession());

class TutorialInSession extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: TutorialInSessionPage(),
    );
  }
}

class TutorialInSessionPage extends StatefulWidget {
  @override
  _TutorialInSessionState createState() => _TutorialInSessionState();
}

class _TutorialInSessionState extends State<TutorialInSessionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OnTheDay()),
              );
            }),
        title: Text('On The Day'),
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnswerPostTest()),
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
