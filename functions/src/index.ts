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


// export const sendPublicNotification = functions.region("asia-southeast1")
//     .firestore.document("/emergencies/{userId}")
//     .onUpdate(async (change, context) => {
//       await (await import("./emergency/publicSignal"))
//           .default(change, context);
//     });

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
