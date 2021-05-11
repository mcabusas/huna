import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../dashboard/dashboard.dart';

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
    print((double.parse(widget.data['bookingData']['rate']) * double.parse(widget.data['bookingData']['numberOfStudents'])).toString());
    setState(() {
      firstName = sp.getString('firstName');
      lastName = sp.getString('lastName');
    });
  }

  initState(){
    super.initState();
    initAwait();
    print('in receipt page');
    print(widget.data['bookingData']['rate']);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Receipt')
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/huna.png'),
                    width: 200,
                    height: 200,
                  ),
                ),
              ),

              Row(
                children: [
                  Text('Student: ' + firstName + ' ' + lastName)
                ],
              ), 

              Row(
                children: [
                  Text('Tutor: ' + widget.data['bookingData']['tutor_firstName'] + ' ' + widget.data['bookingData']['tutor_lastName'])
                ],
              ),
              
              Row(
                children: [
                  Text('Subtotal: ' + widget.data['bookingData']['rate'])
                ],
              ),

              Row(
                children: [
                  Text('Total: ' + (double.parse(widget.data['bookingData']['rate']) * double.parse(widget.data['bookingData']['numberOfStudents'])).toString())
                ],
              ),


            ],
          )
        )
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                DashboardPage()), (Route<dynamic> route) => false);
        },
      ),
      
    );
  }
}