// import * as functions from "firebase-functions";
// import * as admin from "firebase-admin";

import {getFcmDocPromise} from "../toolKit";


// const fcm = admin.messaging();

export default async (
    change: functions.Change<functions.firestore.QueryDocumentSnapshot>,
    context: functions.EventContext,
) => {
  const currentHelpStatus = change.after.data().helpStatus;

  if (change.before.data().isPublic === true &&
    currentHelpStatus != change.before.data().helpStatus) {
    const helpeeUID = context.params.userUID;
    console.log("helpee UID" + helpeeUID);
    const helpeeFcmDocSnap = await getFcmDocPromise(helpeeUID);
    const helpeeFcmToken: string = helpeeFcmDocSnap.get("fcm_token");
    const notificationEnabled: boolean = helpeeFcmDocSnap
        .get("enable_notification");

    const helperUID = String(change.after.data().helperUID);
    const helperEmail = String(change.after.data().helperEmail);
    const helperPhoneNumber = String(change.after.data().helperPhoneNumber);
    const helperDisplayName = String(change.after.data().helperDisplayName);
    const helperPhotoUrl = String(change.after.data().helperPhotoUrl);
    let dataType= "NotADataType";

    switch (currentHelpStatus) {
      case "helperIsHelping":
        dataType = "publicAccepted";
        break;
      case "helperAbort":
        dataType = "helperAbort";
        break;
      case "helperDone":
        dataType = "helperDone";
        break;
    }

    if (notificationEnabled === true) {
      const payload = {
        notification: {
          title: "Your public signal has been accepted by " + helperDisplayName,
          body: helperEmail,
        },
        data: {
          type: dataType,
          helperUID: helperUID,
          helperEmail: helperEmail,
          helperPhoneNumber: helperPhoneNumber,
          helperDisplayName: helperDisplayName,
          helperPhotoUrl: helperPhotoUrl,
        },
      };
      console.log(payload);
      console.log("helpee token" + helpeeFcmToken);
      fcm.sendToDevice(helpeeFcmToken, payload);
    } else {
      const payload = {
        data: {
          type: "publicAccepted",
          helperUID: helperUID,
          helperEmail: helperEmail,
          helperPhoneNumber: helperPhoneNumber,
          helperDisplayName: helperDisplayName,
          helperPhotoUrl: helperPhotoUrl,
        },
      };
      console.log(payload);
      console.log("helpee token" + helpeeFcmToken);
      fcm.sendToDevice(helpeeFcmToken, payload);
    }
  } else {
    return functions
        .logger
        .log("helperRespondToEmergency: (ABORTED) current help status" +
        currentHelpStatus);
  }
};
