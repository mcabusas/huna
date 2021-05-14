const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

exports.newMessages = functions.firestore.document('chatrooms/{chatroomid}/messages/{messageid}').onCreate(async (create, context) => {
    const newData = create.data();
    console.log(newData['sentBy'])
    const user =  admin.firestore().collection('users').doc(newData['sentBy']);
    const userData = await user.get();
    if(!userData.exists){
        console.log('userData is empty');
    }else{
        console.log(userData.data());
    }
    

    const deviceTokens = await admin.firestore().collection('tokens').doc(newData['sentTo']).get();
    console.log(deviceTokens.data()['token']);

    var payload = {
        notification: {title: userData.data()['firstName'] + " " + userData.data()['lastName'] + " sent you a message!", body: newData['message'], sound: 'default'}, 
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'Sample Message'}
    };

    try{
        const response = await admin.messaging().sendToDevice(deviceTokens.data()['tokens'], payload);
        console.log('notification sent!');
    } catch (err) {
        console.log('ERROR IN SENDING MESSAGE NOTIFICATION ' + err);
    }
});


exports.bookingStatusForTutors = functions.firestore.document('bookings/{id}').onUpdate(async (update, context) => {

    const after = update.after.data();
    //aly
    

    const deviceTokens = await admin.firestore().collection('tokens').doc(after.bookingData['tutor_userid']).get();

    var payload = {
        notification: {title: 'Booking Cancelled', body: "Your booking for " + after.bookingData['date'] + " has been cancelled.", sound: 'default'}, 
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'Sample Message'}
    };

    try{
        const response = await admin.messaging().sendToDevice(deviceTokens.data()['tokens'], payload);
        console.log('sent notification');
        console.log(payload);
    } catch (err) {
        console.log('error sending notification');
        console.log(err)
    }



});

exports.newBookings = functions.firestore.document('bookings/{bookingId}').onCreate(async (snapshot, context) => {
    if(snapshot.empty){
        console.log('no device');
    }
    const newData = snapshot.data();



    var payload = {
        notification: {title: 'Booking Request Received', body: newData.bookingData['student_firstName'] + " " + newData.bookingData['student_lastName'] + " has sent you a booking request.", sound: 'default'}, 
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'Sample Message'}
    };
    

    const deviceTokens = await admin.firestore().collection('tokens').doc(newData.bookingData['tutor_userid']).get();

    try{
        const response = await admin.messaging().sendToDevice(deviceTokens.data()['tokens'], payload);
        console.log(payload);
        console.log('sent notification');
    } catch (err) {
        console.log('error sending notification');
        console.log(err)
    }
});

exports.bookingStatusForStudents = functions.firestore.document('bookings/{id}').onUpdate(async (update, context) => {
    //me
    const after = update.after.data();
    

    //var tokens = [];
    

    const deviceTokens = await admin.firestore().collection('tokens').doc(after.bookingData['student_id']).get();
    
    var payloadMessage = '';
    var titleMessage = '';

    

    if (after.bookingData['booking_status'] === "Accepted") {
        titleMessage = "Booking Request Accepted!"
        payloadMessage = after.bookingData['tutor_firstName'] + " " + after.bookingData['tutor_lastName'] + " has " + "accepted " + "your " + "booking "  + "request, " + "A " + "pre-test " + "will " + "be " + "sent " + "to " + "you " + "soon. "
    } else if(after.bookingData['booking_status'] == "Declined") {
        titleMessage = "Booking Request Declined";
        payloadMessage = after.bookingData['tutor_firstName'] + " "+ after.bookingData['tutor_lastName'] +  "has " + "chosen " + "to " + "decline " +  "your " +  "booking " +  "request."
    } else if(after.bookingData['booking_status'] == "Cancelled") {
        titleMessage = "Booking Cancelled.";
        payloadMessage = "Your booking for " + after.bookingData['date'] + " has been cancelled."
    } else if(after.bookingData['booking_status'] == "Ongoing") {
        titleMessage = "Tutorial Session has started."
        payloadMessage = "Your " + "tutorial " +  "session " +  "with " +  after.bookingData['tutor_firstName'] + " " +  after.bookingData['tutor_lastName']  + " has" + "started!"
    } 
    
  
    payload = {
      notification: { title: titleMessage, body: payloadMessage, sound: "default" },
      data: { click_action: 'FLUTTER NOTIFICATION_CLICK', message: 'Tap to Proceed!' }
    };

    try{
        const response = await admin.messaging().sendToDevice(deviceTokens.data()['tokens'], payload);
        console.log('sent notification');
        console.log(payloadMessage);
    } catch (err) {
        console.log('error sending notification');
        console.log(err)
    }
});