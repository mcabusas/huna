const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { onUpdate } = require("firebase-functions/lib/providers/remoteConfig");
const { namespace } = require("firebase-functions/lib/providers/firestore");
admin.initializeApp(functions.config().functions);

var db = admin.database();


exports.newBooking = functions.firestore
  .document('bookings/{id}')
  .onCreate(async () => {
    var tokens = [
      'cDeUVmLuSxu5CykMuvbmSy:APA91bGgSfMXcgFSC4aTQP4EfnZwzwD1MjK-bAvGqjrAtuOGGv0TaxvLqvc-fU7mmRnM2NUZyx46M1Y_41ywZ32u4yl0rTvFiybwQI4ady9SXTLCqihAp1TO6rf9A_SkdmPHfNGnMzSG'
    ];

    var payload = {
      notification: { title: 'Booking!', body: 'Booking was Accepted', sound: 'default' },
      data: { click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'test' }
    };

    try {
      admin.messaging().sendToDevice(tokens, payload);
      console.log("no error");
    } catch (e) {
      console.log("ERROR!");
    }
  })

exports.bookingStatus = functions.firestore.document('bookings/{id}').onUpdate(async (update, context) => {

  const after = update.after.data();
  // var tokens = [
  //   'cDeUVmLuSxu5CykMuvbmSy:APA91bGgSfMXcgFSC4aTQP4EfnZwzwD1MjK-bAvGqjrAtuOGGv0TaxvLqvc-fU7mmRnM2NUZyx46M1Y_41ywZ32u4yl0rTvFiybwQI4ady9SXTLCqihAp1TO6rf9A_SkdmPHfNGnMzSG'
  // ];
  var tokens = [];

  payload = {
    notification: { title: 'Booking Request updated!', body: "Tutor: " + after.bookingData['tutor_firstName'] + " " + after.bookingData['tutor_lastName'] + " has " + after.bookingData['booking_status'] + " your request", sound: "default" },
    data: { click_action: 'FLUTTER NOTIFICATION_CLICK', message: 'Tap to Proceed!' }
  };

  console.log(after.bookingData['student_id']);

  const user = admin
    .firestore()
    .collection("users")
    .doc(`${after.bookingData['student_id']}`);

  user.get().then(doc => {
    if(!doc.exists) {
      console.log('nope');
    }else{
      console.log(doc.data()['device_tokens']);
    }
  });
  // try {
  //   admin.messaging().sendToDevice(tokens, payload);
  // } catch (e) {
  //   console.log('error');
  // }
})
