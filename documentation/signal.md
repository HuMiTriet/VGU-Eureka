# Public and Private Signal
- Signals is the core feature of Etoet. It allows users to decide how they can seek help for themself. There are two types of signals: Public Signal and Private Signal.
- Private Signal is only available for friends, in another words, only friends can see their Private Signal. The disadvantage of this signal is that their friend might not available to help them.
- Public Signal allows all users within the help range of the requester to receive a notification from the person in need of assistance. The minus point of this signal is that the requester's phone number will be public to all the users within the help range.
## Usage
- User press the SOS button at the center bottom in the main view:
![SOS button](/documentation/Collections/SOS_button.png)

- User then fill in the information needed for a `help`:

![SOS help view](/documentation/Collections/SOS_help_view.png)

- The user will then be prompted that they have successfully requested help and the help information will be forwarded to the Firestore:
![SOS user view](/documentation/Collections/SOS_user_view.png)

- Users can also change their request information in this view (problem type, problem description, location description, signal type) and the updated information will be passed to Firestore each time the user edits it. User can cancel their signal by pressing the `MY SITUATION HAS BEEN SOLVED!` button.

- To keep users from seeing where all their information is uploaded, we create a local variable called `isPushed`. This variable will check in the Firestore if the signal of the user currently using the app exists or not everytime the user navigates to the SOS information view. So, if the Signal is pushed to the Firestore, user will be navigated to the SOS screen where their signal information is filled and vice versa.
```dart
    FirestoreEmergency.signalExists(uid: widget.uid).then((value) => {
        isPushed = value,
    });
```
## Limit excessive querying
- Whenever users trying to check their information in the SOS information view, conventionally we will have to query user's request information in the database to fill in all the field in this view.

![SOS information view](/documentation/Collections/SOS_info_view.png)

- This causes unnecessary queries and therefore we don't want this to happen to our database (expensive database operating costs)

- To reduce redundant queries, we introduce a variable named `Emergency`. This variable is located in the parent variable `AuthUser` and stores all information about the user's signal. When the user pushes or updates a signal, the `Emergency` in the `AuthUser` variable will take the user's signal information and stays in the cache memory, so in the next time if user wants to open the SOS information view, the signal information is already available without any Firestore queries needed.

- The debug log shows the cache memory that stores the `Emergency` variable:
![SOS debug log](/documentation/Collections/SOS_debug_log.png)

- Note: This feature is only available when the application is active and the user wants to check their information. If the app restarts, re-querying user's information from Firestore is inevitable.