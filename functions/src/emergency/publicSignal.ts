import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as geofire from "geofire-common";

admin.initializeApp();

const db = admin.firestore();
const rt = admin.database();
const fcm = admin.messaging();

export default async (
    change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
    context: functions.EventContext,
)=> {
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
    const candidatePool: candidateDistanceUID[] = [];

    for (const snap of candidateSnap) {
      snap.forEach((childSnapshot) => {
        const oneCandidateUID = childSnapshot.key;
        // check to see if it is null or undefined
        if (oneCandidateUID) {
          console.log(oneCandidateUID);
          // Eliminate false positie because distance center can have similar
          // geohash if they are adjacent to each other
          const locationRef = childSnapshot.child("location");
          const lat: number = locationRef.child("latitude").val();
          const lng: number = locationRef.child("longitude").val();
          const distanceInKm = geofire.distanceBetween([lat, lng], center);
          const distannceInM = distanceInKm * 1000;
          if (distannceInM < radius) {
            const candidate: candidateDistanceUID = {
              uid: oneCandidateUID,
              distanceInKm: distanceInKm,
            };
            candidatePool.push(candidate);
          }
        }
      });
    }

    // now the candidatesDistanceUID is a list of all the users that is within
    // 20km range of the emergency along with their distance in km.

    // the next step is to filter out all of the candidate that is capable of
    // helping the emergency -> these are called helpers.
    const helperFcmToken: string[] = [];
    for (const oneCandidate of candidatePool) {
      const candidateHelperInfoSnap = await getHelperInfo(oneCandidate.uid);
      if (candidateHelperInfoSnap.get("isHelping") === false) {
        if (oneCandidate.distanceInKm <= candidateHelperInfoSnap
            .get("helpRange")) {
          const helperFcmTokenSnap = await getFcmToken(oneCandidate.uid);
          const oneHelperFcmtoken: string = helperFcmTokenSnap.get("fcm_token");
          helperFcmToken.push(oneHelperFcmtoken);
        }
      }
    }

    // now we check if the token list is empty, if not send a no helper
    // avaliable to the sender.
    if (helperFcmToken.length === 0) {
      const payload = {
        notification: {
          title: "No one available nearby",
          body: "Seems like there is nobody nearby that can help you right now",
        },
      };
      const userFcmTokenSnap = await getFcmToken(userUID);
      const userFcmToken: string = userFcmTokenSnap.get("fcm_token");
      fcm.sendToDevice(userFcmToken, payload);
    } else {
      const locationDescription = String(emergencySnap
          .get("locationDescription"));
      const situtationDetail = String(emergencySnap.get("situtationDetail"));
      const displayName = String(emergencySnap.get("displayName"));
      const payload = {
        notification: {
          title: displayName + " public emergency signal",
          body: situtationDetail,
        },
        data: {
          type: "publicEmergency",
          locationDescription: locationDescription,
          displayName: displayName,
        },
      };

      fcm.sendToDevice(helperFcmToken, payload);
    }
  } else {
    return functions.logger
        .log("Public emergency funciton: not an escalation to  public");
  }
};

interface candidateDistanceUID {
  uid: string;
  distanceInKm: number;
}

/**
 @param {string} uid the unique string that identify a user and is the key
 specifying each user in firestore.
 @return {Promise<DocumentSnapshot<DocumentData>>} Promise that return the
document along with the data inside it (the user's fcm token)
*/
async function getFcmToken(uid: string ):
    Promise<admin.firestore.DocumentSnapshot<admin.firestore.DocumentData>> {
  const fcmTokenRef = db
      .collection("users")
      .doc(uid)
      .collection("notification")
      .doc("fcm_token");

  return fcmTokenRef.get();
}

/**
 @param {string} uid the unique string that identify a user and is the key
*/
async function getHelperInfo(uid: string):
    Promise<admin.firestore.DocumentSnapshot<admin.firestore.DocumentData>> {
  const helperInfoRef = db
      .collection("users")
      .doc(uid)
      .collection("helper")
      .doc("helper");

  return helperInfoRef.get();
}
