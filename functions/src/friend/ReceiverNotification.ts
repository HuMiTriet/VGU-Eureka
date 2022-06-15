import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export default async (
    change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
    context: functions.EventContext,
) => {
  if (change.before.data().requestConfirmed === false &&
      change.after.data().requestConfirmed === true) {
    if (change.before.data().isSender === true) {
      return functions.logger
          .log("from new friend RECEIVER: not receiver message => reject");
    }
    console.log("RECEIVER'S UID: " + context.params.userUID);
    const receiverFriendRef = db
        .collection("users")
        .doc(context.params.friendUID);

    const receiverFriendSnapshot = await receiverFriendRef.get();

    console.log("RECEIVER'S FRIEND INFO");
    const receiverFriendDisplayName = String(receiverFriendSnapshot
        .data()?.displayName);
    console.log(receiverFriendDisplayName);

    const receiverFriendEmail = String(receiverFriendSnapshot
        .data()?.email);
    console.log(receiverFriendEmail);

    const receiverFriendPhotoUrl = String(receiverFriendSnapshot
        .data()?.photoUrl);
    console.log(receiverFriendPhotoUrl);

    const receiverFriendUID = String(receiverFriendSnapshot.data()?.uid);

    const payload = {
      notification: {
        title: receiverFriendDisplayName + " is now your friend",
        body: "Send them a message to say hello",
      },
      data: {
        type: "newFriend",
        displayName: receiverFriendDisplayName,
        email: receiverFriendEmail,
        photoUrl: receiverFriendPhotoUrl,
        uid: receiverFriendUID,
      },
    };

    const receiverTokenRef = db
        .collection("users")
        .doc(context.params.userUID)
        .collection("notification")
        .doc("fcm_token");


    const receiverTokenDoc = await receiverTokenRef.get();
    const receiverToken = receiverTokenDoc.data()?.fcm_token;

    console.log("RECEIVER'S TOKEN: " + receiverToken);

    return fcm.sendToDevice(receiverToken, payload);
  } else {
    return functions.logger
        .log("From new friend RECEIVER: not a new friend established");
  }
};
