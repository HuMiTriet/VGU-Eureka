// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
import {region} from "firebase-functions";
import {initializeApp} from "firebase-admin";

initializeApp();

// firebase emulators:start --import ./emulators_data --export-on-exit
// ./emulators_data

// Promise in typescipt/javascript is the same as Future in dart
export const sendPrivateNotification = region("asia-southeast1").
    firestore.document("/emergencies/{userId}")
    .onCreate(async (snapshot, context) => {
      await (await import("./emergency/privateSignal"))
          .default(snapshot, context);
    });

export const sendPublicNotification = region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./emergency/publicSignal"))
          .default(change, context);
    });

export const sendStraightPublicNotification = region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onCreate(async (snapshot, context) => {
      await (await import("./emergency/straighPublicSignal"))
          .default(snapshot, context);
    });

// Send a notification Annoucing new friend for Sender of that friend reques
export const notifyNewFriendSender = region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
      await (await import("./friend/senderNotification"))
          .default(change, context);
    });

// Send a notification Annoucing new friend for Sender of that friend reques
export const notifyNewFriendReceiver = region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
      await (await import("./friend/ReceiverNotification"))
          .default(change, context);
    });

export const unFriendNotification = region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onDelete(async (snapshot, context) => {
      await (await import("./friend/unFriend"))
          .default(snapshot, context);
    });

export const userUpdateProfileNotification = region("asia-southeast1")
    .firestore.document("/users/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./friend/userUpdateProfileNotification"))
          .default(change, context);
    });

export const newMessageNotification = region("asia-southeast1")
    .firestore.document("chatrooms/{chatroomId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      await (await import("./messaging/newMessage"))
          .default(snapshot, context);
    });

export const newSosMessageNotification = region("asia-southeast1")
    .firestore
    .document("emergencies-chatrooms/{chatroomId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      await (await import("./messaging/newSosMessage"))
          .default(snapshot, context);
    });

export const helperRespondToEmergency = region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./emergency/helperRespondToEmergency"))
          .default(change, context);
    });
