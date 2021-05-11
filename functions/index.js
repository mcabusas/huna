const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

exports.newBookings = functions.firestore.document('bookings/{bookingId}').onCreate(async (snapshot, context) => {
    if(snapshot.empty){
        console.log('no device');
    }
    const newData = snapshot.data();



    var payload = {
        notification: {title: 'Booking Request Received', body: newData.bookingData['student_firstName'] + " " + newData.bookingData['student_lastName'] + " has sent you a booking request.", sound: 'default'}, 
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'Sample Message'}
    };
    

    var tokens = [
        'd7UjP5bOQKCXmuekTr8PSN:APA91bGjAi-_oaB_srEyRxY8xvUeuIOExgKih8SUwjSaydQ8r_pGXKdbOQ-XbXebriezW98twc0qK-i7LD_kTys6EVHPBIxsNG9Wri--SLLvqt5mpRo1ps9Mdgd0LXtbuzcs0sV_ekXT'
    ];

    try{
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log(payload);
        console.log('sent notification');
    } catch (err) {
        console.log('error sending notification');
        console.log(err)
    }
});


exports.newMessages = functions.firestore.document('chatrooms/{chatroomid}/messages/{messageid}').onCreate(async (create, context) => {
    const newData = create.data();
    const user = await admin.firestore().collection('users').doc(newData['sentBy']).get();
    var fName = user.data()['firstName'];
    var lName = user.data()['lastName'];

    var tokens = [
        'd7UjP5bOQKCXmuekTr8PSN:APA91bGjAi-_oaB_srEyRxY8xvUeuIOExgKih8SUwjSaydQ8r_pGXKdbOQ-XbXebriezW98twc0qK-i7LD_kTys6EVHPBIxsNG9Wri--SLLvqt5mpRo1ps9Mdgd0LXtbuzcs0sV_ekXT'
    ];

    var payload = {
        notification: {title: fName + " " + lName + " sent you a message!", body: newData['message'], sound: 'default'}, 
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'Sample Message'}
    };

    try{
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('notification sent!');
    } catch (err) {
        console.log('ERROR IN SENDING MESSAGE NOTIFICATION ' + err);
    }
});

exports.bookingStatusForTutors = functions.firestore.document('bookings/{id}').onUpdate(async (update, context) => {

    const after = update.after.data();
    //aly
    var tokens = [
        'cDeUVmLuSxu5CykMuvbmSy:APA91bGgSfMXcgFSC4aTQP4EfnZwzwD1MjK-bAvGqjrAtuOGGv0TaxvLqvc-fU7mmRnM2NUZyx46M1Y_41ywZ32u4yl0rTvFiybwQI4ady9SXTLCqihAp1TO6rf9A_SkdmPHfNGnMzSG'
    ];

    var payload = {
        notification: {title: 'Booking Cancelled', body: "Your booking for " + after.bookingData['date'] + " has been cancelled.", sound: 'default'}, 
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'Sample Message'}
    };

    try{
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('sent notification');
        console.log(payload);
    } catch (err) {
        console.log('error sending notification');
        console.log(err)
    }



});

exports.bookingStatusForStudents = functions.firestore.document('bookings/{id}').onUpdate(async (update, context) => {
    //me
    const after = update.after.data();
    var tokens = [
        'd7UjP5bOQKCXmuekTr8PSN:APA91bGjAi-_oaB_srEyRxY8xvUeuIOExgKih8SUwjSaydQ8r_pGXKdbOQ-XbXebriezW98twc0qK-i7LD_kTys6EVHPBIxsNG9Wri--SLLvqt5mpRo1ps9Mdgd0LXtbuzcs0sV_ekXT'
    ]; 
    
    
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
    } else if(after.testData['test_sentStatus'] == "1") {
        payloadMessage = after.bookingData['tutor_firstName'] + " " + after.bookingData['tutor_lastName']  + " has sent your a pre-test."
        titleMessage = "Pre-test Received!";
    }
    
  
    payload = {
      notification: { title: titleMessage, body: payloadMessage, sound: "default" },
      data: { click_action: 'FLUTTER NOTIFICATION_CLICK', message: 'Tap to Proceed!' }
    };

    try{
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('sent notification');
        console.log(payloadMessage);
    } catch (err) {
        console.log('error sending notification');
        console.log(err)
    }
});