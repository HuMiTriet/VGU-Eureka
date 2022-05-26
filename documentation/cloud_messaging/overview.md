# Capabilities of Firebase Cloud Messaging (FCM)

- Firebase cloud messaging formerly Google Cloud messaging is a cloud platform 
developed by Google capable of delivering either notification messages or data
messages to the client.

## Notification messages:
- Notification messages will be automatically handled by the FCM SDK, which will
automatically display the message as a push notification on the app's notification
tray if the app is currently running in the background. 
- For the cases that the app is running in the foreground, the message is handled
by a callback function (a function that is passed into another function as a 
parameter which will then be invoked by the outer function to execute something)

## Data messages:
- Send a payload of data that will be handled by app.

*Notification message can also send an optional data message payload*

## Collapsible and non-collapsible messages:
- Non-collapsible: Ensure that every message that is sent will be is delivered.
e.g., A(not send) B(not sent) C(not sent) → send A, B, C

- Collapsible: is a message that will be replaced by a new message if it has not
yet been delivered to the device.
e.g., A(not send) B(not sent) C(not sent) → send C

=> Enabled by
Set the appropriate parameter in your message request: collapseKey on Android
apns-collapse-id on Apple
Topic on Web
collapse_key in legacy protocols (all platforms)

*Except for notification messages, all messages are non-collapsible by default.*

## Setting the priority of the message:
- Normal priority: Delivered immediately when the app is in the foreground, 
when the app is in the background delivery maybe delayed.

- High priority: attempt to deliver the message immediately even if the app is 
in Doze mode (when the app powers off the screen after a period of inactivity)

For more platform specific message priority:

Apple products:
- https://developer.apple.com/library/prerelease/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1

Android:
- https://firebase.google.com/docs/cloud-messaging/android/message-priority

Web:
- https://tools.ietf.org/html/rfc8030#section-5.3
