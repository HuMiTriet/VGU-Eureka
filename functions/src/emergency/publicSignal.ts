// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";
// import * as geohash from "geofire-common";

// admin.initializeApp();

// const db = admin.firestore();
// const rt = admin.database();
// const fcm = admin.messaging();

// export default async (
//     change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
//     context: functions.EventContext,
// ) => {
//   if (change.before.data().isPublic === false &&
//       change.after.data().isPublic === true) {
//     // first we get the location of the emergency
//     const userID = context.params.userId;

//     const emergencyLocationRef = db
//         .collection("emergencies")
//         .doc(userID);

//     const emergencyLocationSnap = await emergencyLocationRef.get();
//     const latLng: number[] = [];

//     // const geopoint = emergencyLocationSnap.data()?
//     //   .position as GeolocationPosition;
//     // latLng.push(geopoint.coords.latitude);
//     // latlng.push(geopoint.coords.longitude);

//   } else {
//     return functions.logger
//         .log("Public emergency funciton: not a escalation to  public");
//   }
// };
