import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {DocumentSnapshot} from "firebase-functions/v1/firestore";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

// firebase emulators:start --import ./emulators_data --export-on-exit
// ./emulators_data

// Promise in typescipt/javascript is the same as Future in dart
export const sendPrivateNotification = functions.region("asia-southeast1").
    firestore.document("/emergencies/{userId}")
    .onCreate(async (snapshot, context) => {
      // immediately exit the function if it is public
      if (snapshot.data().isPublic) {
        return functions.logger
            .log("Private SOS function: not a private signal, reject");
      }
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
        // of the friend we query the database again for their fcm token
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
            token.push(oneFcmTokenSnapshot.data()?.fcm_token);
            console.log(oneFcmTokenSnapshot.data()?.fcm_token);
          }
        });
        const payload = {
          notification: {
            title: "Emergency Alert",
            body: String(snapshot.data()?.message),
            type: "emegency",
          },
          data: {
            type: "emegency",
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
            body: "Please try again later",
          },
        };
        return fcm.sendToDevice(token, errorPayload);
      }
    });
