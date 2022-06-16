import * as functions from "firebase-functions";

// firebase emulators:start --import ./emulators_data --export-on-exit
// ./emulators_data

// Promise in typescipt/javascript is the same as Future in dart
export const sendPrivateNotification = functions.region("asia-southeast1").
    firestore.document("/emergencies/{userId}")
    .onCreate(async (snapshot, context) => {
      await (await import("./emergency/privateSignal"))
          .default(snapshot, context);
    });

export const sendPublicNotification = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./emergency/publicSignal"))
          .default(change, context);
    });

export const sendStraightPublicNotification = functions
    .region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onCreate(async (snapshot, context) => {
      await (await import("./emergency/straighPublicSignal"))
          .default(snapshot, context);
    });

// Send a notification Annoucing new friend for Sender of that friend reques
export const notifyNewFriendSender = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
      await (await import("./friend/senderNotification"))
          .default(change, context);
    });

// Send a notification Annoucing new friend for Sender of that friend reques
export const notifyNewFriendReceiver = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
      await (await import("./friend/ReceiverNotification"))
          .default(change, context);
    });

export const unFriendNotification = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onDelete(async (snapshot, context) => {
      await (await import("./friend/unFriend"))
          .default(snapshot, context);
    });

export const userUpdateProfileNotification = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./friend/userUpdateProfileNotification"))
          .default(change, context);
    });

export const newMessageNotification = functions.region("asia-southeast1")
    .firestore.document("chatrooms/{chatroomId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      await (await import("./messaging/newMessage"))
          .default(snapshot, context);
    });

export const newSosMessageNotification = functions.region("asia-southeast1")
    .firestore
    .document("emergencies-chatrooms/{chatroomId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      await (await import("./messaging/newSosMessage"))
          .default(snapshot, context);
    });

export const acceptPublicEmergency = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./emergency/acceptPublicEmergency"))
          .default(change, context);
    });

export const helperAbortEmergency = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./emergency/helperAbortEmergency"))
          .default(change, context);
    });

export const helperDoneEmergency = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./emergency/helperDoneEmergency"))
          .default(change, context);
    });
