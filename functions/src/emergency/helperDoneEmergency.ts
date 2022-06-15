import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export default async (
    change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
    context: functions.EventContext,
) => {
  const helpStatus = change.after.data().helpStatus;
  if (change.before.data().isPublic === true &&
    helpStatus === "helperDone") {
    const helpeeUID = context.params.userUID;
    console.log("helpee UID" + helpeeUID);
    const helpeeFcmTokenSnap = await getFcmToken(helpeeUID);
    const helpeeFcmToken: string = helpeeFcmTokenSnap.get("fcm_token");

    const helperUID = String(change.after.data().helperUID);
    const helperEmail = String(change.after.data().helperEmail);
    const helperPhoneNumber = String(change.after.data().helperPhoneNumber);
    const helperDisplayName = String(change.after.data().helperDisplayName);
    const helperPhotoUrl = String(change.after.data().helperPhotoUrl);

    const payload = {
      notification: {
        title: helperDisplayName + " has done helping you",
        body: helperEmail,
      },
      data: {
        type: "helperDone",
        helperUID: helperUID,
        helperEmail: helperEmail,
        helperPhoneNumber: helperPhoneNumber,
        helperDisplayName: helperDisplayName,
        helperPhotoUrl: helperPhotoUrl,
      },
    };

    console.log(payload);
    console.log("helpee token" + helpeeFcmToken);

    fcm.sendToDevice(helpeeFcmToken, payload);
  } else {
    return functions
        .logger.log("helperDoneEmergency not executed: emergency " +
        helpStatus);
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
