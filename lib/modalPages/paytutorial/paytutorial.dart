import 'package:flutter/material.dart';
import 'package:huna/modalPages/paytutorial/paypal/paypal_payment.dart';
import 'package:huna/modalPages/paytutorial/receipt/receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'paytutorial_model.dart';
import '../../hunaIcons.dart';




class PayTutorial extends StatefulWidget {
  final data;
  PayTutorial({this.data});
  @override
  _PayTutorialState createState() => _PayTutorialState();
}

class _PayTutorialState extends State<PayTutorial> {

  String uid;
  PaymentTutorial _model = new PaymentTutorial();
  initAwait() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
    });
    print(uid);

  }


  void initState() {
    super.initState();
    initAwait();
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    double amount = (double.parse(widget.data['bookingData']['rate']) * double.parse(widget.data['bookingData']['numberOfStudents']));
    var url = 'https://us-central1-upheld-pursuit-274606.cloudfunctions.net/paypalPayment';
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment'),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.history),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Transactions()),
            //     );
            //   },
            // ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: Column(
            children: <Widget>[
              Text(
                'Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              ListView(
                padding: EdgeInsets.all(15),
                shrinkWrap: true,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {

                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PaypalPayment(data: widget.data,
                              onFinish: (number) async {

                                // payment done
                                print('order id: '+number);

                              },
                            ),
                          ),
                        );
                    },
                    child: Card(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/images/paypal.svg',
                          semanticsLabel: 'A red up arrow',
                          height: 50, 
                          width: 50,
                        ),
                        title: Text('PayPal Payment'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var order = {
                        'subtotal': double.parse(widget.data['bookingData']['rate']),
                        'total': double.parse(widget.data['bookingData']['total']),
                      };
                      bool catcher = await _model.payment(widget.data, order, 'cash');
                      print('this is catcher: ' + catcher.toString());
                        if(catcher == true){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                          Receipt(data: widget.data)), (Route<dynamic> route) => false);
                        }
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(HunaIcons.peso),
                        title: Text('Cash'),
                      ),
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

