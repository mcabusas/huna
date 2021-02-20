import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'package:huna/modalPages/onTheDay_rateReview.dart';
import 'package:huna/modalPages/tutorialInSession/tutorialInSession.dart';

void main() => runApp(AnswerPostTest());

class AnswerPostTest extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: AnswerPostTestPage(),
    );
  }
}

class AnswerPostTestPage extends StatefulWidget {
  @override
  _AnswerPostTestState createState() => _AnswerPostTestState();
}

class _AnswerPostTestState extends State<AnswerPostTestPage> {
  int selectedRadio;
  int correctRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    correctRadio = 0;
  }

  setSelectedRadio(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  setCorrectRadio(int value) {
    setState(() {
      correctRadio = value;
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
                MaterialPageRoute(builder: (context) => TutorialInSession()),
              );
            }),
        title: Text('Post Test'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          // QUESTION NUMBER
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '1',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                // ONLY APPEARS IF ON THE LAST PAGE.
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RateReview()),
                    );
                  },
                  icon: Icon(Icons.check),
                  label: Text('Finish'),
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          // IF DISPLAYING FOR ANSWERING
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30.0),
                child: Text(
                  "Question 1",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              // RADIO SET
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                      value: 1,
                      groupValue: selectedRadio,
                      title: Text("Answer 1"),
                      onChanged: (value) {
                        setSelectedRadio(value);
                      },
                      activeColor: Colors.cyan,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: selectedRadio,
                      title: Text("Answer 2"),
                      onChanged: (value) {
                        setSelectedRadio(value);
                      },
                      activeColor: Colors.cyan,
                    ),
                    RadioListTile(
                      value: 3,
                      groupValue: selectedRadio,
                      title: Text("Answer 2"),
                      onChanged: (value) {
                        setSelectedRadio(value);
                      },
                      activeColor: Colors.cyan,
                    ),
                    RadioListTile(
                      value: 4,
                      groupValue: selectedRadio,
                      title: Text("Answer 2"),
                      onChanged: (value) {
                        setSelectedRadio(value);
                      },
                      activeColor: Colors.cyan,
                    ),
                  ],
                ),
              ),
              // BOTTOM NAVIGATION
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 15.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.deepPurple,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    RawMaterialButton(
                      onPressed: null,
                      child: Text(
                        '1 / 10',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ), // CURRENT PAGE NUMBER
                      shape: CircleBorder(),
                      elevation: 0,
                      // fillColor: Colors.deepPurple.shade300,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    RawMaterialButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.deepPurple,
                      padding: const EdgeInsets.all(15.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
