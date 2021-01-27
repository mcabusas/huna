import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/modalPages/onTheDay_answerPostTest.dart';

void main() => runApp(RateReview());

class RateReview extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        primarySwatch: Colors.blueGrey,
      ),
      home: RateReviewPage(),
    );
  }
}

class RateReviewPage extends StatefulWidget {
  @override
  _RateReviewState createState() => _RateReviewState();
}

class _RateReviewState extends State<RateReviewPage> {
  double rating = 2.5;
  int starCount = 5;

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
                MaterialPageRoute(builder: (context) => AnswerPostTest()),
              );
            }),
        title: Text('Rate & Review'),
      ),
      body: Stack(children: <Widget>[
        // Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/images/bgk.jpg'),
        //       colorFilter: ColorFilter.mode(
        //         Colors.black.withOpacity(0.85),
        //         BlendMode.darken,
        //       ),
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
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
                    //User
                    Center(
                      child: Container(
                        width: 75,
                        height: 75,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/tutor.jpg'),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Jane Dawn',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(child: Text('@extraspace')),
                    Center(child: SizedBox(height: 10)),
                    //user end
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: new StarRating(
                            size: 50.0,
                            rating: rating,
                            color: Colors.amber.shade400,
                            borderColor: Colors.grey,
                            starCount: starCount,
                            onRatingChanged: (rating) => setState(
                              () {
                                this.rating = rating;
                              },
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade900,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: 'Leave a comment.',
                          ),
                        ),
                        SizedBox(height: 20),
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
                            icon: Icon(Icons.send),
                            label: Text('Finish'),
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
          ),
        ),
      ]),
    );
  }
}
