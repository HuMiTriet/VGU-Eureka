import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etoet/services/database/firestore.dart';
import 'package:etoet/views/friend/pending_friend_view.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:provider/provider.dart';

import '../../services/auth/auth_user.dart';
import 'add_friend_view.dart';

class FriendView extends StatefulWidget {
  @override
  const FriendView({Key? key}) : super(key: key);

  @override
  _FriendViewState createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {
  Set<etoet.UserInfo> userListOnSearch = {};

  late AuthUser user;

  //Used to implements some of the search bar's function
  final _searchBarController = TextEditingController();

  //Listener & Stream related
  late Stream<QuerySnapshot> _pendingFriendStream;
  int? pendingFriendRequestCount = 0;

  @override
  void initState() {
    super.initState();
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
      } else if (displayName.contains(keyword)) {
        filteredList.add(friendList.elementAt(i));
        continue;
      }
    }

    return filteredList;
  }

  //Use for filtering list when searching
  // List<String> getListContainsIgnoreCase(
  //     {required List<String> list, required String value}) {
  //   var result = <String>[];
  //   for (var i = 0; i < list.length; ++i) {
  //     if (list.elementAt(i).toLowerCase().contains(value.toLowerCase())) {
  //       result.add(list.elementAt(i));
  //     }
  //   }
  //   return result;
  // }

  //Variables for easier config:

  final double friendViewHeight = 0.9; // Should be between 0.7 - 1.0
  final Color topListViewColor = const Color.fromARGB(200, 255, 210,
      177); // The background color of search and add friend part.
  final Color spacingColor = Colors.orange;
  final Color bottomListViewColor = const Color.fromARGB(
      200, 255, 210, 177); // The background color of friend list.
  static const IconData addFriendIcon = Icons.add;
  static const IconData pendingFriendRequestIcon = Icons.group_add;

  // The relative height of topListView and bottomListView
  // No longer used since widget Flexible is used.
  // final int topListViewFlex = 39;
  // final int bottomListViewFlex = 100;

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();
    _pendingFriendStream = Firestore.firestoreReference
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .where('isSender', isEqualTo: false)
        .where('requestConfirmed', isEqualTo: false)
        .snapshots();
    // pendingFriendRequestReceiverListener = Firestore.pendingFriendRequestReceiverListener(user.uid, context);

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
                color: bottomListViewColor,
                child: Column(
                  children: [
                    // Search, Add Friend and Pending Friend Request.
                    Flexible(
                        //flex: topListViewFlex,
                        child: Container(
                      color: topListViewColor,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          TextField(
                            controller: _searchBarController,
                            decoration: InputDecoration(
                              hintText: 'Search by Display Name',
                              contentPadding: const EdgeInsets.all(20),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _searchBarController.clear();
                                  setState(() {
                                    userListOnSearch = user.friendInfoList;
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              ),
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
                            title: Text('Add Friend'),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 1),
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
                    )),

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
                    Flexible(
                        //flex: bottomListViewFlex,
                        child: Container(
                      color: bottomListViewColor,
                      child: ListView.builder(
                        shrinkWrap: true,
                        // children: userListWidget,
                        // itemCount: user.friendInfoList.length,
                        itemCount: userListOnSearch.isNotEmpty
                            ? userListOnSearch.length
                            : user.friendInfoList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(userListOnSearch
                                      .isNotEmpty
                                  ? userListOnSearch.elementAt(index).photoURL!
                                  : user.friendInfoList
                                      .elementAt(index)
                                      .photoURL!),
                            ),
                            title: Text(userListOnSearch.isNotEmpty
                                ? userListOnSearch.elementAt(index).displayName!
                                : user.friendInfoList
                                    .elementAt(index)
                                    .displayName!),
                            subtitle: Text(userListOnSearch.isNotEmpty
                                ? userListOnSearch.elementAt(index).email!
                                : user.friendInfoList.elementAt(index).email!),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(15)),
                          );
                        },
                      ),
                    )),
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
