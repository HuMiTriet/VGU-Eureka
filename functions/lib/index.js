"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.helperDoneEmergency = exports.helperAbortEmergency = exports.acceptPublicEmergency = exports.newMessageNotification = exports.userUpdateProfileNotification = exports.unFriendNotification = exports.notifyNewFriendReceiver = exports.notifyNewFriendSender = exports.sendPublicNotification = exports.sendPrivateNotification = void 0;
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
exports.sendPublicNotification = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
    await (await Promise.resolve().then(() => require("./emergency/publicSignal")))
        .default(change, context);
});
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
exports.unFriendNotification = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onDelete(async (snapshot, context) => {
    await (await Promise.resolve().then(() => require("./friend/unFriend")))
        .default(snapshot, context);
});
exports.userUpdateProfileNotification = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}")
    .onUpdate(async (change, context) => {
    await (await Promise.resolve().then(() => require("./friend/userUpdateProfileNotification")))
        .default(change, context);
});
exports.newMessageNotification = functions.region("asia-southeast1")
    .firestore.document("chatrooms/{chatroomId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
    await (await Promise.resolve().then(() => require("./messaging/newMessage")))
        .default(snapshot, context);
});
exports.acceptPublicEmergency = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
    await (await Promise.resolve().then(() => require("./emergency/acceptPublicEmergency")))
        .default(change, context);
});
exports.helperAbortEmergency = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
    await (await Promise.resolve().then(() => require("./emergency/helperAbortEmergency")))
        .default(change, context);
});
exports.helperDoneEmergency = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
    await (await Promise.resolve().then(() => require("./emergency/helperDoneEmergency")))
        .default(change, context);
});
//# sourceMappingURL=index.js.map