import 'package:etoet/services/database/firestore.dart';
import 'package:etoet/views/friend/dummyDatabase.dart';
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
  //Dummy database to retrieve friends:
  // DummyDatabase dummyDatabase = DummyDatabase();
  List<String> userDisplayNameList = [];
  List<String> userDisplayNameListOnSearch = [];


  late AuthUser user;

  //A list of ListTile to display Friends.
  //final userListWidget = <Widget>[];

  //Used to implements some of the search bar's function
  final _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // for (var i = 0; i < dummyDatabase.userList.length; ++i) {
    //   userDisplayNameList
    //       .add(dummyDatabase.userList.elementAt(i).displayName!);
    // }
  }




  //Use for filtering list when searching
  List<String> getListContainsIgnoreCase({required List<String> list, required String value})
  {
    var result = <String>[];
    for (var i = 0; i < list.length; ++i) {
      if (list.elementAt(i).toLowerCase().contains(value.toLowerCase())) {
        result.add(list.elementAt(i));
      }
    }
    return result;
  }

  //Variables for easier config:

  final double friendViewHeight = 0.9; // Should be between 0.6 - 1.0
  final Color topListViewColor = Colors.orangeAccent; // The background color of search and add friend part.
  final Color bottomListViewColor = Colors.white; // The background color of friend list.
  static const IconData addFriendIcon = Icons.add;
  static const IconData pendingFriendRequestIcon = Icons.group_add;


  // The relative height of topListView and bottomListView
  final int topListViewFlex = 39;
  final int bottomListViewFlex = 100;



  @override
  Widget build(BuildContext context) {
    user = context.watch<AuthUser>();

    return FutureBuilder(
        future: Firestore.getFriendInfoList(user.uid),
        builder: (context, snapshot){
          if(snapshot.hasData)
            {
              var friendInfoList = snapshot.data as Set<etoet.UserInfo>;
              return FractionallySizedBox(
                  heightFactor: friendViewHeight,
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Search, Add Friend and Pending Friend Request.
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
                                          setState(() {
                                            // userDisplayNameListOnSearch = userDisplayNameList;
                                          });
                                        },
                                        icon: const Icon(Icons.clear),
                                      ),
                                    ),
                                    onChanged: (searchText) {
                                      setState(() {
                                        // userDisplayNameListOnSearch =
                                        //     getListContainsIgnoreCase(list: userDisplayNameList, value: searchText);
                                      });
                                    },
                                  ),
                                  ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(addFriendIcon),
                                    ),
                                    title: Text('Add Friend'),
                                    onTap: ()
                                    {
                                      showBarModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => const AddFriendView(),
                                      );
                                    },


                                  ),
                                  ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(pendingFriendRequestIcon),
                                    ),
                                    title: const Text('Pending Friend Request'),
                                    onTap: ()
                                    {
                                      showBarModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => const PendingFriendView(),
                                      );
                                    },

                                  ),
                                ],
                              ),
                            )),

                        // Friend List
                        Expanded(
                            flex: bottomListViewFlex,
                            child: ListView.builder(
                              shrinkWrap: true,
                              // children: userListWidget,
                              itemCount: friendInfoList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        friendInfoList.elementAt(index).photoURL!
                                    ),
                                  ),
                                  title: Text(friendInfoList.elementAt(index).displayName!),
                                  subtitle: Text(friendInfoList.elementAt(index).email!),
                                );
                              },
                            )),
                      ],
                    ),
                  ));
            }
          else
            {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        }
    );


  }
}
