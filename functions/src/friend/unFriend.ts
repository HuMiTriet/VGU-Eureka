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
  const userTokenPromise = getFcmToken(userUID);

  // Friend is the person whom the user unfriended to (the victim so to speak)
  const friendTokenPromise = getFcmToken(friendUID);

  const userTokenSnap = await userTokenPromise;
  const userToken: string = userTokenSnap.data()?.fcm_token;

  const friendTokenSnap = await friendTokenPromise;
  const friendToken: string = friendTokenSnap.data()?.fcm_token;

  const tokens: string[] = [userToken, friendToken];

  const payload = {
    data: {
      type: "unFriend",
      friendUID: friendUID,
    },
  };
  console.log(payload);

  fcm.sendToDevice(tokens, payload);
};

/**
 @param {string} uid the unique string that identify a user and is the key
 specifying each user in firestore.
 @return {Promise<DocumentSnapshot<DocumentData>>} Promise that return the
document along with the data inside it (the user's fcm token)
*/
async function getFcmToken(uid: string ):
    Promise<admin.firestore.DocumentSnapshot<admin.firestore.DocumentData>> {
  const fcmTokenRef = db
      .collection("users")
      .doc(uid)
      .collection("notification")
      .doc("fcm_token");

  return fcmTokenRef.get();
}

