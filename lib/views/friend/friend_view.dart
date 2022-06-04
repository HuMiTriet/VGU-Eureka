import 'dart:async';
import 'package:etoet/services/database/firestore_friend.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pinput/pinput.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/constants/routes.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/database/firestore.dart';
import 'package:etoet/views/friend/chat_room_view.dart';
import 'package:etoet/views/friend/pending_friend_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../services/auth/auth_user.dart';
import '../../services/database/firestore_chat.dart';
import 'add_friend_view.dart';

class FriendView extends StatefulWidget {
  @override
  const FriendView({Key? key}) : super(key: key);

  @override
  _FriendViewState createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {
  late AuthUser user;
  static late etoet.UserInfo selectedUser;
  Set<etoet.UserInfo> userListOnSearch = {};

  //Used to implements some of the search bar's function
  final _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {
      print('Listened from Friend View!');

      var data = event.data;

      if (data['type'] == 'newFriend') {
        print('new friend notification');
        if (data['uid'] == user.uid) {
          print('Data of self received, skipping...');
        } else {
          var newFriend = etoet.UserInfo(
            uid: data['uid'],
            photoURL: data['photoUrl'],
            email: data['email'],
            displayName: data['displayName'],
          );

          // Very scruffed fix when you got accepted but you have no friend
          //TODO: make for loop run at least once
          if(user.friendInfoList.length == 0)
            {
              setState(() {
                user.friendInfoList.add(newFriend);
              });
              print('Your are now friend with ' + data['displayName']);
            }
          for (var i = 0; i < user.friendInfoList.length; ++i) {
            if (i == (user.friendInfoList.length - 1) &&
                newFriend.uid != user.friendInfoList.elementAt(i).uid) {
              setState(() {
                user.friendInfoList.add(newFriend);
              });
              print('Your are now friend with ' + data['displayName']);
            }
          }
        }
      } else if (data['type'] == 'unFriend') {
        var unfriendFriendUID = data['friendUID'];
        print('unfriend notification');
        if (unfriendFriendUID == user.uid) {
          print('Data of self received, skipping...');
        } else {
          for (var i = 0; i < user.friendInfoList.length; ++i) {
            if (user.friendInfoList.elementAt(i).uid == unfriendFriendUID) {
              var unfriendFriend = user.friendInfoList.elementAt(i);
              setState(() {
                user.friendInfoList.remove(unfriendFriend);
              });
              print('You are now unfriended with ' + unfriendFriendUID);
              break;
            }
          }
        }
      }
    });
  }

  Set<etoet.UserInfo> getFilteredFriendList(
      {required Set<etoet.UserInfo> friendList, required String keyword}) {
    var filteredList = <etoet.UserInfo>{};
    for (var i = 0; i < friendList.length; ++i) {
      //Make all things to lowercase for comparision:
      var email = friendList.elementAt(i).email?.toLowerCase();
      var displayName = friendList.elementAt(i).displayName?.toLowerCase();
      keyword = keyword.toLowerCase();

      //Guard clauses for null check
      if (email == null) continue;
      if (displayName == null) continue;

      //Condition 1: Email
      if (email.contains(keyword)) {
        filteredList.add(friendList.elementAt(i));
        continue;
      }
      //Condition 2: DisplayName
      else if (displayName.contains(keyword)) {
        filteredList.add(friendList.elementAt(i));
        continue;
      }
    }

    return filteredList;
  }

  Future<void> toFriendChatView(int index) async {
    selectedUser = (_searchBarController.text.isNotEmpty)
        ? userListOnSearch.elementAt(index)
        : user.friendInfoList.elementAt(index);
    var chatroomUID = const Uuid().v4().toString();
    await FirestoreChat.createFriendChatroom(
        user.uid, selectedUser.uid, chatroomUID);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatRoomView(selectedUser)),
    );
  }

  //Variables for easier config:

  final double friendViewHeight = 0.9; // Should be between 0.7 - 1.0
  final Color backgroundColor = const Color.fromARGB(200, 255, 210, 177);
  final Color topListViewColor = const Color.fromARGB(200, 255, 210,
      177); // The background color of search and add friend part.
  final Color bottomListViewColor = const Color.fromARGB(
      200, 255, 210, 177); // The background color of friend list.
  final Color spacingColor = Colors.orange;
  static const IconData addFriendIcon = Icons.add;
  static const IconData pendingFriendRequestIcon = Icons.group_add;

  // The relative height of topListView and bottomListView
  // No longer used since widget Flexible is used.
  // final int topListViewFlex = 39;
  // final int bottomListViewFlex = 100;

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();

    //Listener & Stream related
    late Stream<QuerySnapshot> _pendingFriendStream;
    int? pendingFriendRequestCount = 0;

    _pendingFriendStream = FirestoreFriend.getPendingFriendStream(user.uid);

    return StreamBuilder<QuerySnapshot>(
        stream: _pendingFriendStream,
        builder: (context, snapshot) {
          pendingFriendRequestCount = (snapshot.data?.docs.length);
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Text('Loading');
          }
          return FractionallySizedBox(
              heightFactor: friendViewHeight,
              child: SafeArea(
                  child: Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    // Search, Add Friend and Pending Friend Request.
                    Container(
                      color: topListViewColor,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          TextField(
                            controller: _searchBarController,
                            decoration: InputDecoration(
                              hintText: 'Search by Display Name or Email',
                              contentPadding: const EdgeInsets.all(20),
                              // suffixIcon: IconButton(
                              //   onPressed: () {
                              //     _searchBarController.clear();
                              //     setState(() {
                              //       userListOnSearch = user.friendInfoList;
                              //     });
                              //   },
                              //   icon: const Icon(Icons.clear),
                              // ),
                            ),
                            onChanged: (keyword) {
                              setState(() {
                                userListOnSearch = getFilteredFriendList(
                                    friendList: user.friendInfoList,
                                    keyword: keyword);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            leading: Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 2,
                              shadowColor: Colors.black,
                              child: const CircleAvatar(
                                child: Icon(addFriendIcon),
                              ),
                            ),
                            title: const Text('Add Friend'),
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(15)),
                            onTap: () {
                              showBarModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const AddFriendView(),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            leading: Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 2,
                              shadowColor: Colors.black,
                              child: const CircleAvatar(
                                child: Icon(pendingFriendRequestIcon),
                              ),
                            ),
                            title: const Text('Pending Friend Request'),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(15)),
                            onTap: () {
                              showBarModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const PendingFriendView(),
                              );
                            },
                            trailing:
                                Text(pendingFriendRequestCount.toString()),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    Material(
                      color: topListViewColor,
                      elevation: 5,
                      child: SizedBox(
                          height: 40,
                          child: Container(
                            color: spacingColor,
                            child: const Center(
                              child: Text(
                                'Your Friend List',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          )),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    // Friend List
                    Expanded(
                      child: Container(
                        color: bottomListViewColor,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: (_searchBarController.text.isNotEmpty)
                              ? userListOnSearch.length
                              : user.friendInfoList.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    flex: 1,
                                    onPressed: (context) {
                                      selectedUser = (_searchBarController
                                              .text.isNotEmpty)
                                          ? userListOnSearch.elementAt(index)
                                          : user.friendInfoList
                                              .elementAt(index);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Are you sure you want to unfriend ${selectedUser.displayName!}?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    FirestoreFriend
                                                        .deleteFriend(user.uid,
                                                            selectedUser.uid);

                                                    // Not a good way to delete Friend from local friendList
                                                    // Pleased noted to change to listener to database
                                                    user.friendInfoList
                                                        .remove(selectedUser);
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red)),
                                                  child: const Text(
                                                    'Unfriend',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .lightBlue)),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.person_remove,
                                    label: 'Unfriend',
                                  ),
                                  SlidableAction(
                                    flex: 1,
                                    onPressed: (context) {
                                      toFriendChatView(index);
                                    },
                                    backgroundColor: Colors.lightBlue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.chat,
                                    label: 'Chat',
                                  )
                                ],
                              ),
                              child: ListTile(
                                onTap: () async {
                                  toFriendChatView(index);
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userListOnSearch.isNotEmpty
                                          ? userListOnSearch
                                              .elementAt(index)
                                              .photoURL!
                                          : user.friendInfoList
                                              .elementAt(index)
                                              .photoURL!),
                                ),
                                title: Text(
                                    (_searchBarController.text.isNotEmpty)
                                        ? userListOnSearch
                                            .elementAt(index)
                                            .displayName!
                                        : user.friendInfoList
                                            .elementAt(index)
                                            .displayName!),
                                subtitle: Text((_searchBarController
                                        .text.isNotEmpty)
                                    ? userListOnSearch.elementAt(index).email!
                                    : user.friendInfoList
                                        .elementAt(index)
                                        .email!),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )));
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
