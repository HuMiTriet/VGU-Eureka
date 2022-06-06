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
    if (change.before.data().isSender === false) {
      return functions.logger
          .log("from new friend SENDER: not a sender message => reject");
    }
    console.log("SENDER'S UID: " + context.params.userUID);
    const senderFriendRef = db
        .collection("users")
        .doc(context.params.friendUID);

    const senderFriendSnapshot = await senderFriendRef.get();

    console.log("SENDER'S FRIEND INFO:");

    const senderFriendDisplayName = String(senderFriendSnapshot
        .data()?.displayName);
    console.log(senderFriendDisplayName);

    const senderFriendEmail = String(senderFriendSnapshot.data()?.email);
    console.log(senderFriendEmail);

    const senderFriendPhotoUrl = String(senderFriendSnapshot
        .data()?.photoUrl);
    console.log(senderFriendPhotoUrl);

    const senderFriendUID = String(senderFriendSnapshot.data()?.uid);
    console.log(senderFriendUID);

    const payload = {
      notification: {
        title: senderFriendDisplayName +
        " has accepted your friend request",
        body: "Send them a message to say hello",
      },
      data: {
        type: "newFriend",
        displayName: senderFriendDisplayName,
        email: senderFriendEmail,
        photoUrl: senderFriendPhotoUrl,
        uid: senderFriendUID,
      },
    };

    const senderTokenRef = db
        .collection("users")
        .doc(context.params.userUID)
        .collection("notification")
        .doc("fcm_token");

    const senderTokenDoc = await senderTokenRef.get();
    const senderToken = senderTokenDoc.data()?.fcm_token;

    console.log("SENDER'S TOKEN: " + senderToken);

    return fcm.sendToDevice(senderToken, payload);
  } else {
    return functions.logger
        .log("From new friend SENDER: not a new friend established");
  }
};
