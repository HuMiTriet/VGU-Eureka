import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {DocumentSnapshot} from "firebase-functions/v1/firestore";

"use strict";
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendPrivateNotification = functions.region("asia-southeast1").
    firestore.document("/emergencies/{userId}")
    .onCreate(async (snapshot, context) => {
      const userFriendsRef = db.collection("users")
          .doc(context.params.userId).collection("friends");

      try {
        const userFriendsSnapshot = await userFriendsRef.get();
        const tokensPromises: Promise<DocumentSnapshot>[] = [];
        userFriendsSnapshot.forEach((doc) => {
          const p = db.collection("users").doc(doc.data().friendUID).get();
          tokensPromises.push(p);
        });

        const tokensSnapshot = await Promise.all(tokensPromises);

        const tokens: string[] = [];
        tokensSnapshot.forEach((doc) => {
          if (doc.exists) {
            tokens.push(doc.data().token);
          }

        const payload = {
          notification: {
            title: "Emergency Alert",
            body: "Someone is in danger",
            icon: "https://goo.gl/Fz9nrQ"
          }
        };

        return fcm.sendToDevice(tokens, payload);
      } catch (error) {
        console.error(error);
        const error_payload = {
          notification: {
            title: "Error",
            body: "Something went wrong",
            icon: "https://goo.gl/Fz9nrQ"
      }
    }
      }

    });
