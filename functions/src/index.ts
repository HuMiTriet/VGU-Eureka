import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

"use strict";
admin.initializeApp();

export const sendPrivateNotification = functions.region("asia-southeast1").
    firestore.document("/emergencies/{userId}").onCreate((snapshot) => {
      const payload = {
        notification: {
          title: "Emergency",
          body: "Someone is in danger",
        },
      };
      return admin.messaging().sendToDevice(snapshot.data().token, payload);
    });
