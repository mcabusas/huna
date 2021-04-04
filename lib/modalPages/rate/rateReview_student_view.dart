import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:huna/components/profilePicture.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/modalPages/rate/rateReview_model.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RateViewStudent extends StatefulWidget {
  final flag;
  final data;
  RateViewStudent({this.flag, this.data});
  @override
  _RateViewStudentState createState() => _RateViewStudentState();
}

class _RateViewStudentState extends State<RateViewStudent> {

  RateReviewModel _model = new RateReviewModel();

  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> reviewContent = {
    'bookingId': '',
    'rating': 0,
    'review': '',
    's_uid': '',
    't_uid': ''
  };

  double rating = 0.0;
  int starCount = 5;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Form(
              key: _formKey,
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
                      child: FutureBuilder(
                        future: _model.getPicture(widget.data['bookingData']['tutor_userid']),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          Widget retVal;
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            retVal = Container(child: CircularProgressIndicator());
                          }
                          if(snapshot.connectionState == ConnectionState.done){
                            retVal = CircleAvatar(
                              child: ProfilePicture(url: snapshot.data, radius: 40,)
                            );
                          }
                          return retVal;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      //'test',
                      '${widget.data['bookingData']['tutor_firstName']} ${widget.data['bookingData']['tutor_lastName']}',
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
                          starCount: 5,
                          onRatingChanged: (rating) => setState(
                            () {
                              reviewContent['rating'] = rating;
                              this.rating = rating;
                              print(reviewContent['rating']);
                            },
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade900,
                      ),
                      TextFormField(
                        validator: (val){
                          if(val.isEmpty){
                            return 'Please enter a comment';
                          }
                          return null;
                        },
                        onChanged: (val){
                          reviewContent['review'] = val;
                        },
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
                          onPressed: () async {
                            setState(() {
                              reviewContent['bookingId'] = widget.data['bookingId'];
                              reviewContent['s_uid'] = widget.data['bookingData']['student_id'];
                              reviewContent['t_uid'] = widget.data['bookingData']['tutor_userid'];
                            });
                            print(reviewContent);
                            //print(widget.flag);
                            _model.addReview(reviewContent, widget.flag).catchError((e)=>{
                              print(e.toString())
                            });
                            Fluttertoast.showToast(
                                msg: "Thank you!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            DashboardPage()), (Route<dynamic> route) => false);
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
    );
  }
}
