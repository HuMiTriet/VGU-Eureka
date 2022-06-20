import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();
/**
 This file provides all of the common static functions that will be used by the
 many different cloud functions.
*/

/**
 @param {string} uid the unique string that identify a user and is the key
 specifying each user in firestore. returns an empty string if the user has
 turned off notification.
 @return {Promise<DocumentSnapshot<DocumentData>>} Promise that return the
 document along with the data inside it (the user's fcm token)
*/
export async function getFcmToken(uid: string):
  Promise<[string, boolean]> {
  const fcmTokenRef = db
      .collection("users")
      .doc(uid)
      .collection("notification")
      .doc("fcm_token");

  const fcmTokenSnap = await fcmTokenRef.get();

  const fcmToken = fcmTokenSnap.get("fcm_token");
  const notificationEnabled = fcmTokenSnap.get("enable_notification");

  return [fcmToken, notificationEnabled];
}
