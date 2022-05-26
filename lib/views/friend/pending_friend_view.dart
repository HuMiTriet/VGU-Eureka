import 'package:etoet/services/auth/user_info.dart' as etoet;
import 'package:etoet/services/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_user.dart';

class PendingFriendView extends StatefulWidget {
  @override
  const PendingFriendView({Key? key}) : super(key: key);

  @override
  _PendingFriendViewState createState() => _PendingFriendViewState();
}

class _PendingFriendViewState extends State<PendingFriendView> {
  final _searchBarController = TextEditingController();
  late AuthUser user;

  @override
  void initState() {
    super.initState();
  }

  //Variables for easier config:
  final double pendingFriendViewHeight = 0.9; // Should be between 0.6 - 1.0
  final Color topListViewColor = Colors
      .orangeAccent; // The background color of search and add friend part.
  final Color bottomListViewColor =
      Colors.white; // The background color of friend list.

  // The relative height of topListView and bottomListView
  final int topListViewFlex = 11;
  final int bottomListViewFlex = 101;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    user = context.watch<AuthUser>();
    return FutureBuilder(
        future: Firestore.getPendingRequestUserInfo(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pendingUserInfoList = snapshot.data as Set<etoet.UserInfo>;
            // print(pendingUserInfoList.length.toString());
            // print(pendingUserInfoList.elementAt(0).displayName);
            return FractionallySizedBox(
              heightFactor: pendingFriendViewHeight,
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
                                  hintText: 'Search',
                                  contentPadding: const EdgeInsets.all(20),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _searchBarController.clear();
                                      pendingUserInfoList = {};
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),

                    //Pending Friend List
                    Expanded(
                        flex: bottomListViewFlex,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: pendingUserInfoList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        pendingUserInfoList
                                            .elementAt(index)
                                            .photoURL!),
                                  ),
                                  title: Text(
                                    pendingUserInfoList
                                        .elementAt(index)
                                        .displayName!,
                                  ),
                                  subtitle: Text(
                                    pendingUserInfoList.elementAt(index).email!,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Firestore.deleteFriendRequest(
                                              user.uid,
                                              pendingUserInfoList
                                                  .elementAt(index)
                                                  .uid);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Firestore.acceptFriendRequest(
                                              user.uid,
                                              pendingUserInfoList
                                                  .elementAt(index)
                                                  .uid);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ));
                            })),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
