import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

import {DocumentSnapshot} from "firebase-functions/v1/firestore";

export default async (
    snapshot: functions.firestore.QueryDocumentSnapshot,
    context: functions.EventContext,
) => {
  // immediately exit the function if it is public
  if (snapshot.data().isPublic) {
    return functions.logger
        .log("Private SOS function: not a private signal, reject");
  }
  // getting the regerence pointing at the user friend collection
  const userFriendsRef = db.collection("users")
      .doc(context.params.userId).collection("friends")
      .where("requestConfirmed", "==", true);

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
    const displayName = String(snapshot.get("displayName"));
    const photoUrl = String(snapshot.get("photoUrl"));
    const helpeeUID = String(snapshot.get("uid"));

    const payload = {
      notification: {
        title: displayName + "'s Private Alert",
        body: String(snapshot.data()?.situationDetail),
      },
      data: {
        type: "privateEmegency",
        displayName: displayName,
        helpeeUID: helpeeUID,
        photoUrl: photoUrl,
        locationDescription: String(snapshot.data()?.locationDescription),
        situationDetail: String(snapshot.data()?.situationDetail),
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
};
