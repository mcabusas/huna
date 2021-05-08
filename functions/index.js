const functions = require("firebase-functions");
const braintree = require("braintree");
const gateway = new braintree.BraintreeGateway({
  environment: braintree.Environment.Sandbox,
  merchantId: "w5n3q86xk87fw8cc",
  publicKey: "xf7mqyq3nygnhxzx",
  privateKey: "b3425a03f75660e8ee956316390f0acf"
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// // });
// var braintree = require('braintree');


// var gateway = new braintree.BraintreeGateway({
//   environment: braintree.Environment.Sandbox,
//   merchantId: "w5n3q86xk87fw8cc",
//   publicKey: "xf7mqyq3nygnhxzx",
//   privateKey: "b3425a03f75660e8ee956316390f0acf"
// });



exports.paypalPayment = functions.https.onRequest(async (req, res) => {
  console.log('THIS IS DOPE');
  // const nonce = "fake-nonce"
  // const deviceData = req.body.device_data;

  gateway.transaction.sale({
    amount: '5.00',
    paymentMethodNonce: 'nonce-from-the-client',
    options: {
      submitForSettlement: true
    }
  }, function (err, result) {
    if (err) {
      console.error(err);
      return;
    }
  
    if (result.success) {
      console.log('Transaction ID: ' + result.transaction.id);
    } else {
      console.error(result.message);
    }
  });
});