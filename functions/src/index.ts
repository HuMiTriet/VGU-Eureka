import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {DocumentSnapshot} from "firebase-functions/v1/firestore";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

// firebase emulators:start --import ./emulators_data --export-on-exit
// ./emulators_data

// Promise in typescipt/javascript is the same as Future in dart
export const sendPrivateNotification = functions.region("asia-southeast1").
    firestore.document("/emergencies/{userId}")
    .onCreate(async (snapshot, context) => {
<<<<<<< HEAD
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
        const friendFcmTokenPromises: Promise<DocumentSnapshot>[] = [];
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
        const token: string[] = [];
        tokenSnapshot.forEach((oneFcmTokenSnapshot) => {
          if (oneFcmTokenSnapshot.data()?.enable_notification) {
            token.push(oneFcmTokenSnapshot.data()?.fcm_token);
            console.log(oneFcmTokenSnapshot.data()?.fcm_token);
          }
        });
        const payload = {
          notification: {
            title: "Emergency Alert",
            body: String(snapshot.data()?.message),
          },
          data: {
            type: "emegency",
          },
        };
        return fcm.sendToDevice(token, payload);
      } catch (error) {
        // get the sender token
        const senderRef = db.collection("users")
            .doc(context.params.userId)
            .collection("notification")
            .doc("fcm_token");
        const senderTokenSnapshot = await senderRef.get();
        const token = senderTokenSnapshot.data()?.fcm_token;
        const errorPayload = {
          notification: {
            title: "Sorry we couldn't proccess your request",
            body: "Please try again later",
          },
        };
        return fcm.sendToDevice(token, errorPayload);
      }
=======
      await (await import("./emergency/privateSignal"))
          .default(snapshot, context);
    });

export const sendPublicNotification = functions.region("asia-southeast1")
    .firestore.document("/emergencies/{userUID}")
    .onUpdate(async (change, context) => {
      await (await import("./emergency/publicSignal"))
          .default(change, context);
>>>>>>> 490fc234ea7bc815e996f5fbe0aa59e434e8ea1e
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

        const senderFriendDisplayName = String(senderFriendSnapshot
            .data()?.displayName);
        console.log(senderFriendDisplayName);

        const senderFriendEmail = String(senderFriendSnapshot.data()?.email);
        console.log(senderFriendEmail);

        const senderFriendPhotoUrl = String(senderFriendSnapshot
            .data()?.photoUrl);
        console.log(senderFriendPhotoUrl);

        const senderFriendUID = String(senderFriendSnapshot.data()?.uid);
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
        const senderToken = senderTokenDoc.data()?.fcm_token;

        console.log("SENDER'S TOKEN: " + senderToken);

        return fcm.sendToDevice(senderToken, payload);
      } else {
        return functions.logger
            .log("From new friend SENDER: not a new friend established");
      }
    });

// Send a notification Annoucing new friend for Sender of that friend reques
export const notifyNewFriendReceiver = functions.region("asia-southeast1")
    .firestore.document("/users/{userUID}/friends/{friendUID}")
    .onUpdate(async (change, context) => {
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
        const receiverFriendDisplayName = String(receiverFriendSnapshot
            .data()?.displayName);
        console.log(receiverFriendDisplayName);

        const receiverFriendEmail = String(receiverFriendSnapshot
            .data()?.email);
        console.log(receiverFriendEmail);

        const receiverFriendPhotoUrl = String(receiverFriendSnapshot
            .data()?.photoUrl);
        console.log(receiverFriendPhotoUrl);

        const receiverFriendUID = String(receiverFriendSnapshot.data()?.uid);

        const payload = {
          notification: {
            title: receiverFriendDisplayName + " is now your friend",
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
        const receiverToken = receiverTokenDoc.data()?.fcm_token;

        console.log("RECEIVER'S TOKEN: " + receiverToken);

        return fcm.sendToDevice(receiverToken, payload);
      } else {
        return functions.logger
            .log("From new friend RECEIVER: not a new friend established");
      }
    });

<<<<<<< HEAD

=======
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

// export
// const autofillDefaultUserPhotoUrl = functions.region("asia-southeast1")
//     .auth.user().onCreate(async (user) => {
//       await (await import("./auth/autofillUserPhotoUrl"))
//           .default(user);
//     });
>>>>>>> 490fc234ea7bc815e996f5fbe0aa59e434e8ea1e
