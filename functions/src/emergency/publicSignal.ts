import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as geofire from "geofire-common";

admin.initializeApp();

const db = admin.firestore();
const rt = admin.database();
// const fcm = admin.messaging();

export default async (
    change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
    context: functions.EventContext,
) => {
  if (change.before.data().isPublic === false &&
      change.after.data().isPublic === true) {
    const userUID: string = context.params.userUID;
    // Since the maximum helping range of the app is 20km, the first task is
    // to get all of the users that is within 20km range of the emergency to
    // narrom down.

    // first the geopoint of the emergency must be retreived
    const emergencyRef = db
        .collection("emergencies")
        .doc(userUID);

    const emergencySnap = await emergencyRef.get();

    const geohash = emergencySnap.get("position.geohash");
    console.log(geohash);

    const geopoint: admin.firestore.GeoPoint = emergencySnap
        .get("position.geopoint");

    const latitiude: number = geopoint.latitude;
    const longtitude: number = geopoint.longitude;
    const center = [latitiude, longtitude];

    const radius = 20 * 1000;

    const bounds = geofire.geohashQueryBounds(center, radius);

    const helperCandidatePromise: Promise<admin.database.DataSnapshot>[] = [];
    const rootRef = rt.ref("users");

    for (const b of bounds) {
      const query = rootRef
          .orderByChild("geohash")
          .startAt(b[0])
          .endAt(b[1]);

      helperCandidatePromise.push(query.get());
    }

    const candidateSnap = await Promise.all(helperCandidatePromise);
    const candidatesUID: string[] = [];

    for (const snap of candidateSnap) {
      snap.forEach((childSnapshot) => {
        const oneCandidateUID = childSnapshot.key;
        // check to see if it is null or undefined
        if (oneCandidateUID) {
          console.log(oneCandidateUID);
          candidatesUID.push(oneCandidateUID);
        }
      });
    }

    // now the candidatesUID is a list of all the users that is within 20km
    // range of the emergency.

    // the next step is to filter out all of the candidate that is capable of
    // helping the emergency -> these are called helpers.
  } else {
    return functions.logger
        .log("Public emergency funciton: not a escalation to  public");
  }
};


