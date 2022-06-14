import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export default async (
    change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
    context: functions.EventContext,
) => {
  if (change.before.data().isPublic === true &&
    change.after.data().senderUID != undefined) {
    const helpeeUID = context.params.userUID;
    const helpeeFcmTokenSnap = await getFcmToken(helpeeUID);
    const helpeeFcmToken: string = helpeeFcmTokenSnap.get("fcm_token");

    const helperUID = change.after.data().helperUID;
    const helperEmail = change.after.data().helperEmail;
    const helperPhoneNumber = change.after.data().helperPhoneNumber;
    const helperDisplayName = change.after.data().helperDisplayName;
    const helperPhotoUrl = change.after.data().helperPhotoUrl;

    const payload = {
      notification: {
        title: "No one available nearby",
        body: "Seems like there is nobody nearby that can help you right now",
      },
      data: {
        type: "publicAccepted",
        helperUID: helperUID,
        helperEmail: helperEmail,
        helperPhoneNumber: helperPhoneNumber,
        helperDisplayName: helperDisplayName,
        helperPhotoUrl: helperPhotoUrl,
      },
    };

    fcm.sendToDevice(helpeeFcmToken, payload);
  } else {
    return functions
        .logger.log("acceptPublicMessage: Public signal not accepted");
  }
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
