import 'dart:core';
import 'package:flutter/material.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/payment/payment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'paypal_services.dart';
import '../paytutorial_model.dart';
import '../receipt/receipt.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final dynamic data;
  PaypalPayment({this.onFinish, this.data});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();
  PaymentTutorial _model = PaymentTutorial();

  // you can change default currency according to your need
  Map<dynamic,dynamic> defaultCurrency = {"symbol": "PHP ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "PHP"};

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL= 'cancel.example.com';

  String itemName;
  String itemPrice = '1.99';
  String firstName;
  String lastName;
  int quantity = 1;

  SharedPreferences sp;

  Future initAwait() async {
    sp = await SharedPreferences.getInstance();
    print(widget.data['bookingData']['rate'].runtimeType);
    print((double.parse(widget.data['bookingData']['rate']) * double.parse(widget.data['bookingData']['numberOfStudents'])).toString());
    setState(() {
      firstName = sp.getString('firstName');
      lastName = sp.getString('lastName');
      itemName = 'Student: $firstName $lastName - Tutor: ${widget.data['bookingData']['tutor_firstName']} ${widget.data['bookingData']['tutor_lastName']}';
      // quantity = int.parse(widget.data['bookingData']['numberOfStudents']);
    });
  }


  @override
  void initState() {
    super.initState();

    initAwait();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: '+e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    


    // checkout invoice details
    String totalAmount = (double.parse(widget.data['bookingData']['rate']) * double.parse(widget.data['bookingData']['numberOfStudents'])).toString();
    String subTotalAmount = (double.parse(widget.data['bookingData']['rate']) * double.parse(widget.data['bookingData']['numberOfStudents'])).toString();
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'Gulshan';
    String userLastName = 'Yadav';
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = '+919990119091';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount":
                  ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": [],
            if (isEnableShipping &&
                isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName +
                    " " +
                    userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": returnURL,
        "cancel_url": cancelURL
      }
    };
    return temp;
  }

  // Map<String, dynamic> getOrderParams() {
  //   // checkout invoice details
  //   String totalAmount = (double.parse(widget.data['bookingData']['rate']) * double.parse(widget.data['bookingData']['numberOfStudents'])).toString();
  //   String subTotalAmount = widget.data['bookingData']['rate'];
  //   String shippingCost = '0';
  //   int shippingDiscountCost = 0;
  //   String userFirstName = firstName;
  //   String userLastName = lastName;
  //   String addressCity = 'Cebu City';
  //   String addressStreet = widget.data['bookingData']['location'];
  //   String addressZipCode = '6000';
  //   String addressCountry = 'Philippines';
  //   String addressState = 'Cebu';
  //   String addressPhoneNumber = '+639999999999';

  //   Map<String, dynamic> temp = {
  //     "intent": "sale",
  //     "payer": {"payment_method": "paypal"},
  //     "transactions": [
  //       {
  //         "amount": {
  //           "total": totalAmount,
  //           "currency": defaultCurrency["currency"],
  //           "details": {
  //             "subtotal": subTotalAmount,
  //             "shipping": shippingCost,
  //             "shipping_discount":
  //                 ((-1.0) * shippingDiscountCost).toString()
  //           }
  //         },
  //         "description": "The payment transaction description.",
  //         "payment_options": {
  //           "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
  //         },
  //         "item_list": {
  //           "items": [
              
  //           ],
  //           if (isEnableShipping &&
  //               isEnableAddress)
  //             "shipping_address": {
  //               "recipient_name": userFirstName +
  //                   " " +
  //                   userLastName,
  //               "line1": addressStreet,
  //               "line2": "",
  //               "city": addressCity,
  //               "country_code": addressCountry,
  //               "postal_code": addressZipCode,
  //               "phone": addressPhoneNumber,
  //               "state": addressState
  //             },
  //         }
  //       }
  //     ],
  //     "note_to_payer": "Contact us for any questions on your order.",
  //     "redirect_urls": {
  //       "return_url": returnURL,
  //       "cancel_url": cancelURL
  //     }
  //   };
  //   return temp;
  // }

  @override
  Widget build(BuildContext context) {
    //print(checkoutUrl);
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) async {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                  //Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
                print('onEEEE');
              }
              // Navigator.of(context).pop();
              print('twOOOO');
             bool catcher = await _model.payment(widget.data, Map<String, dynamic>.from(getOrderParams()), 'paypal');
             print('this is catcher: ' + catcher.toString());
              if(catcher == true){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                Receipt(data: widget.data)), (Route<dynamic> route) => false);
              }
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}