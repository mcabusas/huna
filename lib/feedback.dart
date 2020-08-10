import 'package:flutter/material.dart';
import 'package:huna/bookings.dart';
import 'package:huna/dashboard.dart';
import 'package:huna/favorites.dart';
import 'package:huna/login.dart';
import 'package:huna/payment.dart';
import 'package:huna/messages.dart';
import 'package:huna/secondaryPages/myProfile.dart';
import 'package:http/http.dart' as http;



class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {
  var jsonData;


  updateFeedback() async{
    var data = {
      'id': u.id,
      'content': feedbackController.text,
      'rating': rate.toString(),
    };

    final response = await http.post("http://capstonehuna-com.preview-domain.com/database_files/feedback.php", body: data);

    if(response.statusCode == 200){
      setState(() {
        jsonData = response.body;
      });
      print(jsonData);
    }
  }

  final TextEditingController feedbackController = new TextEditingController();

  bool rate1 = false; // Very Bad
  bool rate2 = false;
  bool rate3 = false;
  bool rate4 = false;
  bool rate5 = false; // Very Good
  int rate;

  // Slider
  var rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false, // Prevents overflowing
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('John Smith'),
              accountEmail: Text('@hunabetatester'), //Use Username Instead
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              onDetailsPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile()),
                );
              },
            ),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.date_range),
                title: Text('Bookings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Bookings()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Messages'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Messages()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Payment'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Payment()),
                  );
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.info),
                title: Text('Feedback'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackPage()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'We want to hear from you.',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Send us your suggestions and concerns. We'll get back to you as soon as we can.",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Reactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.sentiment_very_dissatisfied, size: 40),
                      color: rate1 ? Colors.red.shade800 : Colors.grey.shade900,
                      onPressed: () {
                        setState(() {
                          rate1 = !rate1;
                          rate2 = false;
                          rate3 = false;
                          rate4 = false;
                          rate5 = false;
                          rate = 1;
                        });
                      }),
                  IconButton(
                      icon: Icon(Icons.sentiment_dissatisfied, size: 40),
                      color:
                          rate2 ? Colors.amber.shade800 : Colors.grey.shade900,
                      onPressed: () {
                        setState(() {
                          rate1 = false;
                          rate2 = !rate2;
                          rate3 = false;
                          rate4 = false;
                          rate5 = false;
                          rate = 2;
                        });
                      }),
                  IconButton(
                      icon: Icon(Icons.sentiment_neutral, size: 40),
                      color:
                          rate3 ? Colors.yellow.shade600 : Colors.grey.shade900,
                      onPressed: () {
                        setState(() {
                          rate1 = false;
                          rate2 = false;
                          rate3 = !rate3;
                          rate4 = false;
                          rate5 = false;
                          rate = 3;
                        });
                      }),
                  IconButton(
                      icon: Icon(Icons.sentiment_satisfied, size: 40),
                      color: rate4
                          ? Colors.lightGreen.shade500
                          : Colors.grey.shade900,
                      onPressed: () {
                        setState(() {
                          rate1 = false;
                          rate2 = false;
                          rate3 = false;
                          rate4 = !rate4;
                          rate5 = false;
                          rate = 4;
                        });
                      }),
                  IconButton(
                      icon: Icon(Icons.sentiment_very_satisfied, size: 40),
                      color:
                          rate5 ? Colors.green.shade800 : Colors.grey.shade900,
                      onPressed: () {
                        setState(() {
                          rate1 = false;
                          rate2 = false;
                          rate3 = false;
                          rate4 = false;
                          rate5 = !rate5;
                          rate = 5;
                        });
                      }),
                ],
              ),
              
              SizedBox(height: 20),
              Divider(
                color: Colors.grey.shade900,
              ),
              Column(
                children: <Widget>[
                  TextFormField(
                    controller: feedbackController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 15,
                    decoration: InputDecoration(
                      hintText: 'Comments / Suggestions',
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton.icon(
                      onPressed: () {
                        updateFeedback();
                      },
                      icon: Icon(Icons.send),
                      label: Text('Send'),
                      color: Colors.grey.shade900,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
