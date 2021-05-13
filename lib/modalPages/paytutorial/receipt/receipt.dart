import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../dashboard/dashboard.dart';
import 'package:flutter/material.dart';
// import 'dart:math' as math;

class Receipt extends StatefulWidget {
  final data;
  Receipt({this.data});
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  SharedPreferences sp;
  String firstName, lastName;

  Future initAwait() async {
    sp = await SharedPreferences.getInstance();
    print(widget.data['bookingData']['rate'].runtimeType);
    print((double.parse(widget.data['bookingData']['rate']) *
            double.parse(widget.data['bookingData']['numberOfStudents']))
        .toString());
    setState(() {
      firstName = sp.getString('firstName');
      lastName = sp.getString('lastName');
    });
  }

  initState() {
    super.initState();
    initAwait();
    print('in receipt page');
    print(widget.data['bookingData']['rate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Receipt'), elevation: 0),
      backgroundColor: Colors.grey.shade900,
      body: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 125),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage('assets/images/huna.png'),
                width: 80,
                height: 80,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outlined,
                    size: 80,
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      'Payment Successful!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Text('Student',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(firstName + ' ' + lastName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Tutor', style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                      widget.data['bookingData']['tutor_firstName'] +
                          ' ' +
                          widget.data['bookingData']['tutor_lastName'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Tutor Rate',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(widget.data['bookingData']['rate'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Total', style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text((double.parse(widget.data['bookingData']['rate']) *
                          double.parse(
                              widget.data['bookingData']['numberOfStudents']))
                      .toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            // Align(
            //   alignment: Alignment.center,
            //   child: CustomPaint(
            //     size: MediaQuery.of(context).size,
            //     painter: MyPainter(),
            //   ),
            // ),
          ],
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => DashboardPage()),
              (Route<dynamic> route) => false);
        },
      ),
    );
  }
}

// class MyPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     paint.color = Colors.blue;
//     paint.style = PaintingStyle.fill;

//     paintZigZag(canvas, paint, Offset(0, 100), Offset(200, 100), 100, 5);
//   }

//   void paintZigZag(Canvas canvas, Paint paint, Offset start, Offset end,
//       int zigs, double width) {
//     assert(zigs.isFinite);
//     assert(zigs > 0);
//     canvas.save();
//     canvas.translate(start.dx, start.dy);
//     end = end - start;
//     canvas.rotate(math.atan2(end.dy, end.dx));
//     final double length = end.distance;
//     final double spacing = length / (zigs * 2.0);
//     final Path path = Path()..moveTo(0.0, 0.0);
//     for (int index = 0; index < zigs; index += 1) {
//       final double x = (index * 2.0 + 1.0) * spacing;
//       final double y = width * ((index % 2.0) * 2.0 - 1.0);
//       path.lineTo(x, y);
//     }
//     path.lineTo(length, 0.0);
//     canvas.drawPath(path, paint);
//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
