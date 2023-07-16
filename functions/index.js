/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


exports.payment = onRequest((request, response) => {
  const result = request.body.Body.stkCallback;

  if (result.ResultCode === 0) {
    response.status(200).send("Payment received successfully");
    logger.info("Payment received successfully", result.CheckoutRequestID);
    const record = admin.firestore()
      .collection("pending_payments")
      .doc(result.CheckoutRequestID)
      .get();
    record.then((doc) => {
      logger.info("Document", doc.data());
      const data = doc.data();
      // eslint-disable-next-line max-len
      const { userId, amount, time, phoneNumber, paymentMethod, orderId, vendorId } = data;
      logger.info("User ID", userId, "Amount", amount);

      admin.firestore()
        .collection("payments")
        .doc(userId)
        .set({
          userId: userId,
          time: time,
          amount: amount,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
          orderId: orderId,
          vendorId: vendorId
        }).then((docRef) => {
          admin.firestore()
            .collection("pending_payments")
            .doc(result.CheckoutRequestID)
            .delete();
          logger.info("Document written with ID: ", docRef);
        }).catch((error) => {
          logger.error("Error adding document: ", error);
        });
    });
  } else {
    response.status(400).send("Payment not received");
    logger.info("Payment not received", result.CheckoutRequestID);
    admin.firestore()
      .collection("pending_payments")
      .doc(result.CheckoutRequestID)
      .delete();
  }
});