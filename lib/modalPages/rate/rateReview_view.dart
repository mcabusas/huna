import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/modalPages/onTheDay_answerPostTest.dart';
import 'rateReview_student_view.dart';
import 'rateReview_tutor_view.dart';


class RateReviewView extends StatefulWidget {
  final data;
  final flag;
  RateReviewView({this.data, this.flag});
  @override
  _RateReviewState createState() => _RateReviewState();
}

class _RateReviewState extends State<RateReviewView> {
  double rating = 2.5;
  int starCount = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data['bookingData']);
    print(widget.flag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => AnswerPostTest()),
              // );
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
        widget.flag == 0 ?
        RateViewStudent(flag: widget.flag, data: widget.data) :
        RateViewTutor(flag: widget.flag, data: widget.data)
        
      ]),
    );
  }
}
