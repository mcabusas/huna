import 'package:flutter/material.dart';
import 'package:huna/modalPages/paytutorial/paypal/paypal_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';




class PayTutorial extends StatefulWidget {
  final data;
  PayTutorial({this.data});
  @override
  _PayTutorialState createState() => _PayTutorialState();
}

class _PayTutorialState extends State<PayTutorial> {

  String uid;

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

                      // var request =  BraintreeDropInRequest(
                      //   tokenizationKey: 'sandbox_6m9w58hh_w5n3q86xk87fw8cc',
                      //   collectDeviceData: true,
                      //   paypalRequest: BraintreePayPalRequest(
                      //     amount: amount.toString(),
                      //     displayName: uid.toString()
                      //   ),
                      //   cardEnabled: true
                      // );
                      
                      // BraintreeDropInResult result = await BraintreeDropIn.start(request).catchError((e) => print(e.toString()));
                      // if(result != null) {
                      //   print(result.paymentMethodNonce.description);
                      //   print(result.paymentMethodNonce.nonce);

                      //   //final http.Response response = await http.post(Uri.tryParse('https://us-central1-upheld-pursuit-274606.cloudfunctions.net/paypalPayment?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}&amount=$amount'));
                        
                      //   //final payResult = jsonDecode(response.body);
                      //   // if(payResult['result'] == 'success') {print('done');} else(print('ERROR ON THE PAYPAL PAGE, MAYBE THE CLOUD FUNCTIONS?'));
                      //     Navigator.pushReplacement(
                      //                 context, MaterialPageRoute(builder: (BuildContext context) => DashboardPage()));
                      //     Fluttertoast.showToast(
                      //               msg: "Payment complete!",
                      //               toastLength: Toast.LENGTH_SHORT,
                      //               gravity: ToastGravity.BOTTOM,
                      //               timeInSecForIos: 1,
                      //               backgroundColor: Colors.blue,
                      //               textColor: Colors.white,
                      //               fontSize: 16.0
                      //           );

                          
                           
                      // }else {
                      //   print(result);
                      //   print('in else'); 
                      // }
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
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text('Cash'),
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

