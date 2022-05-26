import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

// export const helloWorld = functions.region("asia-southeast1").
//     https.onRequest((request, response) => {
//       functions.logger.info("Hello logs!", {structuredData: true});
//       response.send("Hello from Firebase!");
//     });

export const sendPrivateNotification = functions.region("asia-southeast1").
    firestore.document("/emergencies/{userId}").onCreate((snap) => {
      const payload = {
        notification: {
          title: "Emergency",
        },
      };
      return admin.messaging().sendToDevice(snap.data().token, payload);
    });
