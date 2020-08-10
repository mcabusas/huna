import 'package:flutter/material.dart';
import 'package:huna/dashboard.dart';
import 'package:huna/modalPages/bookings_onTheDay.dart';

void main() => runApp(SOS());

class SOS extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: SOSPage(),
    );
  }
}

class SOSPage extends StatefulWidget {
  @override
  _SOSState createState() => _SOSState();
}

class _SOSState extends State<SOSPage> {
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
        title: Text('SOS'),
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
                    // Center(child: SizedBox(height: 80)),                    
                    Container(
                      padding: EdgeInsets.all(20.0),
                      height: 450,
                      width: 350,                      
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.warning,
                            color: Colors.red.shade800,
                            size: 100.0,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Emergency contact has been alerted.",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Your booking details have been sent to your registered emergency contact.",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Divider(
                              // height: 5,
                              thickness: 5,
                            ),
                          ),
                         ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPage()),
                          );
                        },
                        icon: Icon(Icons.assignment),
                        label: Text('Finish Tutorial'),
                        color: Colors.deepPurple,
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
