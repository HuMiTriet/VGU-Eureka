// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
// import * as geohash from "geofire-common";

// admin.initializeApp();

// const db = admin.firestore();
// const fcm = admin.messaging();

// export default async (
//     change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
//     context: functions.EventContext,
// ) => {
//   if (change.before.data().isPublic === false &&
//       change.after.data().isPublic === true) {
//     return functions.logger
//         .log("Public emergency funciton: not a escalation to  public");
//   } else {
//   }
// };
