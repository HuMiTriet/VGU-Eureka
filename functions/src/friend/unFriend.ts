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
  const userTokenPromise = getFcmToken(context, userUID);

  // Friend is the person whom the user unfriended to (the victim so to speak)
  const friendTokenPromise = getFcmToken(context, friendUID);

  const userTokenSnap = await userTokenPromise;
  const userToken: string = userTokenSnap.data()?.fcm_token;

  const friendTokenSnap = await friendTokenPromise;
  const friendToken: string = friendTokenSnap.data()?.fcm_token;

  // const fcmTokens = await Promise
  // .all([userTokenPromise, friendTokenPromise]);

  // const userToken = fcmTokens[0].data()?.fcm_token;
  // const friendToken = fcmTokens[1].data()?.fcm_token;

  const tokens: string[] = [userToken, friendToken];

  const payload = {
    data: {
      type: "unFriend",
      userUID: userUID,
      friendUID: friendUID,
    },
  };
  console.log(payload);

  fcm.sendToDevice(tokens, payload);
};

/**
 @param {functions.EventContext} context provide the path to the specific user
 @param {string} uid the unique string that identify a user and is the key
 specifying each user in firestore.
 @return {Promise<DocumentSnapshot<DocumentData>>} Promise that return the
document along with the data inside it (the user's fcm token)
*/
async function getFcmToken(context: functions.EventContext, uid: string ):
    Promise<admin.firestore.DocumentSnapshot<admin.firestore.DocumentData>> {
  const fcmTokenRef = db
      .collection("users")
      .doc(uid)
      .collection("notification")
      .doc("fcm_token");

  return fcmTokenRef.get();
}

