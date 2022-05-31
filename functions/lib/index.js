"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.notifyNewFriendReceiver = exports.notifyNewFriendSender = exports.sendPrivateNotification = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();
// firebase emulators:start --import ./emulators_data --export-on-exit
// ./emulators_data
// Promise in typescipt/javascript is the same as Future in dart
exports.sendPrivateNotification = functions.region("asia-southeast1").
    firestore.document("/emergencies/{userId}")
    .onCreate(async (snapshot, context) => {
    var _a, _b;
    // immediately exit the function if it is public
    if (snapshot.data().isPublic) {
        return functions.logger
            .log("Private SOS function: not a private signal, reject");
    }
    // getting the regerence pointing at the user friend collection
    const userFriendsRef = db.collection("users")
        .doc(context.params.userId).collection("friends");
    // getting all of the user's friends collection (database query require
    // async interaction with the database)
    try {
        // The usage of async here is because a user can potential have a lot
        // of frriends
        const userFriendCollectionSnapshot = await userFriendsRef.get();
        // Store each of the user's friend promise into an array, for each
        // of the friend we query the database again for their fcm token
        const friendFcmTokenPromises = [];
        // query the user friend collection for the uid -> find the fcm token
        userFriendCollectionSnapshot.forEach(async (oneFriend) => {
            const oneFcmToken = db.collection("users")
                .doc(oneFriend.data().friendUID)
                .collection("notification")
                .doc("fcm_token")
                .get();
            friendFcmTokenPromises.push(oneFcmToken);
        });
        const tokenSnapshot = await Promise.all(friendFcmTokenPromises);
        const token = [];
        tokenSnapshot.forEach((oneFcmTokenSnapshot) => {
            var _a, _b, _c;
            if ((_a = oneFcmTokenSnapshot.data()) === null || _a === void 0 ? void 0 : _a.enable_notification) {
                token.push((_b = oneFcmTokenSnapshot.data()) === null || _b === void 0 ? void 0 : _b.fcm_token);
                console.log((_c = oneFcmTokenSnapshot.data()) === null || _c === void 0 ? void 0 : _c.fcm_token);
            }
        });
        const payload = {
            notification: {
                title: "Emergency Alert",
                body: String((_a = snapshot.data()) === null || _a === void 0 ? void 0 : _a.message),
            },
            data: {
                type: "emegency",
            },
        };
        return fcm.sendToDevice(token, payload);
    }
    catch (error) {
        // get the sender token
        const senderRef = db.collection("users")
            .doc(context.params.userId)
            .collection("notification")
            .doc("fcm_token");
        const senderTokenSnapshot = await senderRef.get();
        const token = (_b = senderTokenSnapshot.data()) === null || _b === void 0 ? void 0 : _b.fcm_token;
        const errorPayload = {
            notification: {
                title: "Sorry we couldn't proccess your request",
                body: "Please try again later",
            },
        };
        return fcm.sendToDevice(token, errorPayload);
    }
});
// Send a notification Annoucing new friend for Sender of that friend reques
exports.notifyNewFriendSender = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
    var _a, _b, _c, _d, _e;
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
        const senderFriendDisplayName = String((_a = senderFriendSnapshot
            .data()) === null || _a === void 0 ? void 0 : _a.displayName);
        console.log(senderFriendDisplayName);
        const senderFriendEmail = String((_b = senderFriendSnapshot.data()) === null || _b === void 0 ? void 0 : _b.email);
        console.log(senderFriendEmail);
        const senderFriendPhotoUrl = String((_c = senderFriendSnapshot
            .data()) === null || _c === void 0 ? void 0 : _c.photoUrl);
        console.log(senderFriendPhotoUrl);
        const senderFriendUID = String((_d = senderFriendSnapshot.data()) === null || _d === void 0 ? void 0 : _d.uid);
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
        const senderToken = (_e = senderTokenDoc.data()) === null || _e === void 0 ? void 0 : _e.fcm_token;
        console.log("SENDER'S TOKEN: " + senderToken);
        return fcm.sendToDevice(senderToken, payload);
    }
    else {
        return functions.logger
            .log("From new friend SENDER: not a new friend established");
    }
});
// Send a notification Annoucing new friend for Sender of that friend reques
exports.notifyNewFriendReceiver = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
    var _a, _b, _c, _d, _e;
    if (change.before.data().requestConfirmed === false &&
        change.after.data().requestConfirmed === true) {
        if (change.before.data().isSender === true) {
            return functions.logger
                .log("from new friend RECEIVER: not receiver message => reject");
        }
        console.log("RECEIVER'S UID: " + context.params.userUID);
        const receiverFriendRef = db
            .collection("users")
            .doc(context.params.friendUID);
        const receiverFriendSnapshot = await receiverFriendRef.get();
        console.log("RECEIVER'S FRIEND INFO");
        const receiverFriendDisplayName = String((_a = receiverFriendSnapshot
            .data()) === null || _a === void 0 ? void 0 : _a.displayName);
        console.log(receiverFriendDisplayName);
        const receiverFriendEmail = String((_b = receiverFriendSnapshot
            .data()) === null || _b === void 0 ? void 0 : _b.email);
        console.log(receiverFriendEmail);
        const receiverFriendPhotoUrl = String((_c = receiverFriendSnapshot
            .data()) === null || _c === void 0 ? void 0 : _c.photoUrl);
        console.log(receiverFriendPhotoUrl);
        const receiverFriendUID = String((_d = receiverFriendSnapshot.data()) === null || _d === void 0 ? void 0 : _d.uid);
        const payload = {
            notification: {
                title: receiverFriendDisplayName +
                    " has accepted your friend request",
                body: "Send them a message to say hello",
            },
            data: {
                type: "newFriend",
                displayName: receiverFriendDisplayName,
                email: receiverFriendEmail,
                photoUrl: receiverFriendPhotoUrl,
                uid: receiverFriendUID,
            },
        };
        const receiverTokenRef = db
            .collection("users")
            .doc(context.params.userUID)
            .collection("notification")
            .doc("fcm_token");
        const receiverTokenDoc = await receiverTokenRef.get();
        const receiverToken = (_e = receiverTokenDoc.data()) === null || _e === void 0 ? void 0 : _e.fcm_token;
        console.log("RECEIVER'S TOKEN: " + receiverToken);
        return fcm.sendToDevice(receiverToken, payload);
    }
    else {
        return functions.logger
            .log("From new friend RECEIVER: not a new friend established");
    }
});
//# sourceMappingURL=index.js.map