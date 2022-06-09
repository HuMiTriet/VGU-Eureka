// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";

// admin.initializeApp();

// const db = admin.firestore();
// const fcm = admin.messaging();

// export default async (
//     change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
//     context: functions.EventContext,
// ) => {
//   const userSnap = change.after.data();
//   const userDisplayName = String(userSnap.displayName);
//   const userEmail = String(userSnap.email);
//   const userPhotoUrl = String(userSnap.photoUrl);
//   const userUID = context.params.userUID;
//   const payload = {
//     data: {
//       type: "friendDataChanged",
//       displayName: userDisplayName,
//       email: userEmail,
//       photoUrl: userPhotoUrl,
//       uid: userUID,
//     },
//   };

//   // the next step is to get the list of all of the user's friends uid
// };
