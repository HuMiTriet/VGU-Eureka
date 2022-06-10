import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {DocumentSnapshot} from "firebase-functions/v1/firestore";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export default async (
    change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
    context: functions.EventContext,
) => {
  const userSnap = change.after.data();
  const userDisplayName = String(userSnap.displayName);
  const userEmail = String(userSnap.email);
  const userPhotoUrl = String(userSnap.photoUrl);
  const userUID = context.params.userUID;

  const payload = {
    data: {
      type: "friendDataChanged",
      displayName: userDisplayName,
      email: userEmail,
      photoUrl: userPhotoUrl,
      uid: userUID,
    },
  };

  console.log(payload);
  console.log(context.params.userUID);

  // the next step is to get the list of all of the user's friends uid
  const userFriendsRef = db.collection("users")
      .doc(context.params.userUID).collection("friends")
      .where("requestConfirmed", "==", true);

  const userFriendCollectionSnapshot = await userFriendsRef.get();

  const friendFcmTokenPromises: Promise<DocumentSnapshot>[] = [];

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
      console.log("FRIEND FCM " + oneFcmTokenSnapshot.data()?.fcm_token);
      token.push(oneFcmTokenSnapshot.data()?.fcm_token);
    }
  });

  if (token.length === 0) {
    functions.logger
        .log("userUpdateProfileNotification: user dont have any friend");
  } else {
    fcm.sendToDevice(token, payload);
  }
};
