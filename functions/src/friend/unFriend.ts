import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export default async (
    snapshot: functions.firestore.QueryDocumentSnapshot,
    context: functions.EventContext,
) => {
  const userUID: string = context.params.userUID;
  const friendUID: string = context.params.friendUID;
  // user here is the person who initialized the unfriend request
  const userToken = await getFcmToken(context, userUID);

  // Friend is the person whom the user unfriended to (the victim so to speak)
  const friendToken = await getFcmToken(context, friendUID);

  const tokens: string[] = [userToken, friendToken];

  const payload = {
    data: {
      type: "unFriend",
      userUID: userUID,
      friendUID: friendUID,
    },
  };

  fcm.sendToDevice(tokens, payload);
};

/**
 @param {functions.EventContext} context provide the path to the specific user
 @param {string} uid the unique string that identify a user and is the key
 specifying each user in firestore.
*/
async function getFcmToken(context: functions.EventContext, uid: string ) {
  const fcmTokenRef = db
      .collection("users")
      .doc(uid)
      .collection("notification")
      .doc("fcm_token");

  const fcmTokenSnap = await fcmTokenRef.get();

  return fcmTokenSnap.data()?.fcm_token;
}

