const functions = require("firebase-functions");


const admin = require("firebase-admin");
admin.initializeApp();

exports.test = functions.https.onCall((data, context) => {
  let fName = "";
  if (!data.firstName) {
    fName = data.firstName;
  }
  return fName;
});

