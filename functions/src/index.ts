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
      // getting the regerence pointing at the user friend collection
      const userFriendsRef = db.collection("users")
          .doc(context.params.userId).collection("friends");
      // getting all of the user's friends collection (database query require
      // async interaction with the database)
      try {
        // The usage of async here is because a user can potential have a lot
        // of frriends
        const userFriendCollectionSnapshot = await userFriendsRef.get();
        // Store each of the user's friend promise into an array, for each
        // of the friend where query the database again for their fcm token
        const friendFcmTokenPromises: Promise<DocumentSnapshot>[] = [];
        // query the user friend collection for the uid -> find the fcm token
        userFriendCollectionSnapshot.forEach(async (oneFriend) => {
          const oneFcmToken = db.collection("users")
              .doc(oneFriend.data().friendUID)
              .collection("notification")
              .doc("fcm_token")
              .get();
          friendFcmTokenPromises.push(oneFcmToken);
        });
        const tokenSnapshot = await Promise.all(friendFcmTokenPromises);
        const token: string[] = [];
        tokenSnapshot.forEach((oneFcmTokenSnapshot) => {
          if (oneFcmTokenSnapshot.data()?.enable_notification) {
            token.push(oneFcmTokenSnapshot.data()?.token);
          }
        });
        const payload = {
          notification: {
            title: "Emergency Alert",
            body: "Someone is in danger",
          },
        };
        return fcm.sendToDevice(token, payload);
      } catch (error) {
        // get the sender token
        const senderRef = db.collection("users")
            .doc(context.params.userId)
            .collection("notification")
            .doc("fcm_token");
        const senderTokenSnapshot = await senderRef.get();
        const token = senderTokenSnapshot.data()?.fcm_token;
        const errorPayload = {
          notification: {
            title: "Sorry we couldn't proccess your request",
            body: "Please try again after a short few miniute",
          },
        };
        return fcm.sendToDevice(token, errorPayload);
      }
    });
