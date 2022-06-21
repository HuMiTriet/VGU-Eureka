// import * as admin from "firebase-admin";
import {firestore, messaging} from "firebase-admin";
import {MessagingDevicesResponse, MessagingOptions, MessagingPayload}
  from "firebase-admin/lib/messaging/messaging-api";
// const db = admin.firestore();
// const fcm = admin.messaging();
/**
 This file provides all of the common static functions that will be used by the
 many different cloud functions.
*/

/**
 @param {string} uid the unique string that identify a user and is the key
 specifying each user in firestore.
 @return {Promise<DocumentSnapshot<DocumentData>>} Promise that return the
document along with the data inside it (the user's fcm token)
*/
export async function getFcmDocPromise(uid: string):
  Promise<firestore.DocumentSnapshot<firestore.DocumentData>> {
  const fcmDocRef = firestore()
      .collection("users")
      .doc(uid)
      .collection("notification")
      .doc("fcm_token");

  return fcmDocRef.get();
}

/**
  @param registrationTokenOrTokens: string 
*/
export async function FcmSendToDevice(
    registrationTokenOrTokens: string | string[],
    payload: MessagingPayload,
    options?: MessagingOptions | undefined
): Promise<MessagingDevicesResponse> {
  return messaging().sendToDevice(registrationTokenOrTokens, payload, options);
}
