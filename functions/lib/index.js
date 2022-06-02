"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notifyNewFriendReceiver = exports.notifyNewFriendSender = exports.sendPrivateNotification = void 0;
const functions = require("firebase-functions");
// firebase emulators:start --import ./emulators_data --export-on-exit
// ./emulators_data
// Promise in typescipt/javascript is the same as Future in dart
exports.sendPrivateNotification = functions.region("asia-southeast1").
    firestore.document("/emergencies/{userId}")
    .onCreate(async (snapshot, context) => {
    await (await Promise.resolve().then(() => require("./emergency/privateSignal")))
        .default(snapshot, context);
});
// export const sendPublicNotification = functions.region("asia-southeast1")
//     .firestore.document("/emergencies/{userId}")
//     .onUpdate(async (change, context) => {
//       if (change.before.data().isPublic === false &&
//           change.after.data().isPublic === true) {
//         return functions.logger
//             .log("Public emergency funciton: not a escalation to  public");
//       } else {
//         // dynamic import only load the geohash module for this function to
//         // reduce cold start
//         const geohash = await import("geofire-common");
//       }
//     });
// Send a notification Annoucing new friend for Sender of that friend reques
exports.notifyNewFriendSender = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
    await (await Promise.resolve().then(() => require("./friend/senderNotification")))
        .default(change, context);
});
// Send a notification Annoucing new friend for Sender of that friend reques
exports.notifyNewFriendReceiver = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
    await (await Promise.resolve().then(() => require("./friend/ReceiverNotification")))
        .default(change, context);
});
//# sourceMappingURL=index.js.map