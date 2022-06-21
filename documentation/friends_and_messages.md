# Friend View
## Add Friend View
- Users can type the friend's name in app to add friends
- It connects to the Firestore Database and check the collections 'users' which displays email and displayName
- It works by checking the email of the users
- It searches user info lists by email, uid, displayName and photoURL
### Sending Friend Request
- When users send friend request to other friends, they will be sender and it will detect as the sender uid
- Its FirestoreFriend will search the uid and email of the users and it will detect as the receiver uid
- When it completes, it will clear the list friends and show the text 'Friend request send'
## Pending Friend View
- It fetches the user info from the uid in the collection 'users' by searching  userUID, after confirming the friend request, it moves the sender uid to the friend's info list
### Get Pending Request User Info
- PendingFriendInfoList is fetched by the UserInfo from the friendUID
- Friend request will be sent to the receiver uid, and when the user click on the button 'confirm' then they are friends
### Get Accepted User Info
- PendingFriendRequestData is fetch data from the friendUID when the user confirm the request
- PendingFriendInfo is fetched data from userInfo, which is 'friendUID'
- When the PendingFriendInfo is confirmed then it will be added into the PendingFriendInfoList
### Accept Friend Request
- When the sender user (senderUID) send the friend request to the receiver user (receiverUID) in the Firestore Database.
- Its data is fetched from collection 'users' -> docs (senderUID/receiverUID) -> collection 'friends' -> docs (receiverUID/senderUID) and then it will update the request confirm if the 2nd user is received the friend request from other
### Delete Friend Request
- When the receiver user (receiverUID) delete the friend request from the sender user (senderUID) in the Firestore Database.
- Its data is fetched from collection 'users' -> docs (senderUID/receiverUID) -> collection 'friends' -> docs (receiverUID/senderUID) and then it will update the request confirm if the 2nd user is received the friend request from other
## Friend View
- It shows the friendInfoList from the friendData if they are still friend
- It has some multiple functions in friend list such as search friends, add friends, unfriends or pending friend request
### Pending Friend Request Receiver Listener
- When data is changed in friendInfoList (receiverUID), which changes the requestConfirmed from false -> true
- After that, it will listen the new changes and it notifies the receiver user that you have received the friend request from the sender user (senderUID)
### Pending Friend Request Sender Listener
- When data is changed in friendInfoList (senderUID), which changes the isSender from false -> true
- After that, it will listen the new changes and it notifies the sender user that you have sent the friend request to the receiver user (receiverUID)
## Chat Room View
- When users want to chat with their friends they should click on their friend's Info which is shown in the friend list (avatar, displayName, email)
### Get Chat Room UID
- It will store data (chatroomUID) in the Firestore Database (collection ' users' -> doc 'user1UID -> collection 'friends' -> doc 'user2UID)
### Create Friend Chat Room
- Each chatroom will have each distinct chatroomUID
- Firstly, It will check that whether this chatroom is already exist or not. If it exists it will move to the old friend chatroom, if it does not exists it will create chatroom for them (By comparing the chatroomUID)
#### New Friend Chat Room
- If both of them have not chat yet, it will create 2 userUID for 2 users (1 for user, 1 for his/her friend) to the Firestore Database, and then creating new chatroom
#### Old Friend Chat Room
- If both of them have already chat together, it will store this chatroom (chatroomUID) with 2 userUID(userUID1 and userUID2) in the Firestore Database
### Set Message
- It contains chatroomUID, message, senderUID, senderDisplayName, timestamp
- It compares the senderUID with lastMessageUserUID, If it is true it will return that the senderUID is from the userUID1, If it is false it will return that the senderUID is from userUID2
- Timestamp is fetched data from Timestamp.now() function which means that it will return the current time
### Get Message Stream
- It is the place where the message from both of users send peer-to-peer and it is ordered by timestamp descending, and it will be shown from the top to bottom
- Its message is stored in the Firestore Database (collection 'chatrooms' -> doc 'chatroomUID' -> collection 'messages')