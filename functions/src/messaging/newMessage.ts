import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export default async (
    snapshot: functions.firestore.QueryDocumentSnapshot,
    context: functions.EventContext,
) => {
  const chatroomId = context.params.chatroomId;

  const message = String(snapshot.get("message"));
  const senderUID = String(snapshot.get("senderUID"));

  // getting all of the information about the sender
  const senderDisplayName = String(snapshot.get("senderDisplayName"));

  const payload = {
    notification: {
      title: senderDisplayName,
      body: message,
    },
    data: {
      type: "newMessage",
      senderUID: senderUID,
    },
  };
  console.log(payload);

  const chatroomRef = db
      .collection("chatrooms")
      .doc(chatroomId);

  const chatroomSnap = await chatroomRef.get();

  const user1UID = chatroomSnap.get("user1UID");
  const user2UID = chatroomSnap.get("user2UID");

  let receiverUID = String();
  // determine which is the receiver
  if (user1UID === senderUID) {
    receiverUID = user2UID;
  } else if (user2UID === senderUID) {
    receiverUID = user1UID;
  }

  console.log(receiverUID);

  const receiverFcmTokenSnap = await getFcmToken(receiverUID);
  const receiverFcmToken = receiverFcmTokenSnap.get("fcm_token");

  console.log(receiverFcmToken);

  fcm.sendToDevice(receiverFcmToken, payload);
};

/**
 @param {string} uid the unique string that identify a user and is the key
 specifying each user in firestore.
 @return {Promise<DocumentSnapshot<DocumentData>>} Promise that return the
document along with the data inside it (the user's fcm token)
*/
async function getFcmToken(uid: string):
    Promise<admin.firestore.DocumentSnapshot<admin.firestore.DocumentData>> {
  const fcmTokenRef = db
      .collection("users")
      .doc(uid)
      .collection("notification")
      .doc("fcm_token");

  return fcmTokenRef.get();
}
