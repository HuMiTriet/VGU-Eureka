import 'package:etoet/services/auth/auth_user.dart';
import 'package:etoet/services/database/firestore/firestore.dart';
import 'package:etoet/services/database/firestore/firestore_friend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AddFriendView extends StatefulWidget {
  @override
  const AddFriendView({Key? key}) : super(key: key);

  @override
  _AddFriendViewState createState() => _AddFriendViewState();
}

class _AddFriendViewState extends State<AddFriendView> {
  late AuthUser user;
  //Used to implements some of the search bar's function
  final _searchBarController = TextEditingController();
  Set<etoet.UserInfo> searchedUserInfoList = {};

  @override
  void initState() {
    super.initState();
    searchedUserInfoList = {};
  }

  //Variables for easier config:
  final double addFriendViewHeight = 0.9; // Should be between 0.6 - 1.0
  final Color topListViewColor = Colors
      .orangeAccent; // The background color of search and add friend part.
  final Color bottomListViewColor =
      Colors.white; // The background color of friend list.

  // The relative height of topListView and bottomListView
  final int topListViewFlex = 11;
  final int bottomListViewFlex = 101;

  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();
    return FractionallySizedBox(
      heightFactor: addFriendViewHeight,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: topListViewFlex,
                child: Container(
                  color: topListViewColor,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TextField(
                        controller: _searchBarController,
                        decoration: InputDecoration(
                          hintText: 'Search by Email',
                          contentPadding: const EdgeInsets.all(20),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              if (_searchBarController.text.isNotEmpty) {
                                searchedUserInfoList =
                                    await FirestoreFriend.getUserInfoFromEmail(
                                        _searchBarController.text, user.uid);
                              } else {
                                searchedUserInfoList.clear();
                              }
                              setState(() {});
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            // Friend List
            Expanded(
                flex: bottomListViewFlex,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchedUserInfoList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              searchedUserInfoList.elementAt(index).photoURL!),
                        ),
                        title: Text(
                          searchedUserInfoList.elementAt(index).displayName!,
                        ),
                        subtitle: Text(
                          searchedUserInfoList.elementAt(index).email!,
                        ),
                        trailing: IconButton(
                          onPressed: () async {

                            if(await FirestoreFriend.
                            isOtherUserSentFriendRequest(user.uid, searchedUserInfoList.elementAt(index).uid))
                              {
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: const Center(
                                            child: Text('This user has already sent you a friend request!'),
                                        ),
                                        content: const Text('Please check pending friend request menu to accept/reject request'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Confirm'),
                                          ),
                                        ],
                                      );
                                    }
                                    );
                              }
                            else
                              {
                                FirestoreFriend.sendFriendRequest(user.uid,
                                    searchedUserInfoList.elementAt(index).uid);

                                searchedUserInfoList =
                                await FirestoreFriend.getUserInfoFromEmail(
                                    _searchBarController.text, user.uid);

                                //Clear list after sent a friend request
                                setState(() {});
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Friend Request Sent!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text('Confirm'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }

                          },
                          icon: const Icon(Icons.add),
                        ));
                  },
                )),
          ],
        ),
      ),
    );
  }
}

