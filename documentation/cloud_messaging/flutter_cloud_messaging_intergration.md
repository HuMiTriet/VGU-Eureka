# Three ways to send a message using FCM:
- Using the Firebase message composer: send push notification or in app messages
(best use for organizing promotion/events/campaigns or A/B testing)

- Publisher/Subscriber model: Client can create and subscribe to topics but the
message it self must be send via the cloud functions using the admin SDK.

- Cloud function: to send the message using the firebase admin sdk in a secure
preconfigured Nodejs environment. 

[Reference:]( https://firebase.google.com/docs/cloud-messaging/send-message#send-messages-to-multiple-devices)

# State of the device that the app can be in:
- 
