import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

class RateViewTutor extends StatefulWidget {
  final flag;
  final data;
  RateViewTutor({this.flag, this.data});
  @override
  _RateViewTutorState createState() => _RateViewTutorState();
}

class _RateViewTutorState extends State<RateViewTutor> {

  Map<String, dynamic> reviewContent = {
    'bookingId': '',
  };

  double rating = 0;
  int starCount = 5;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      backgroundImage: AssetImage('assets/images/tutor.jpg'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '${widget.data['bookingData']['student_firstName']} ${widget.data['bookingData']['student_lastName']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                //Center(child: Text('@extraspace')),
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
                            print(this.rating);
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => DashboardPage()),
                          // );
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
    );
  }
}
