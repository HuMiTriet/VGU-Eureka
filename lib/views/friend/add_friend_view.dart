
import 'package:etoet/services/database/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:etoet/services/auth/user_info.dart' as etoet;


class AddFriendView extends StatefulWidget {
  @override
  const AddFriendView({Key? key}) : super(key: key);

  @override
  _AddFriendViewState createState() => _AddFriendViewState();
}

class _AddFriendViewState extends State<AddFriendView>{

  //Used to implements some of the search bar's function
  final _searchBarController = TextEditingController();
  Set<etoet.UserInfo> searchedUserInfoList = {};


  @override
  void initState(){
    super.initState();
    searchedUserInfoList = {};
  }

  //Variables for easier config:
  final double addFriendViewHeight = 0.9; // Should be between 0.6 - 1.0
  final Color topListViewColor = Colors.orangeAccent; // The background color of search and add friend part.
  final Color bottomListViewColor = Colors.white; // The background color of friend list.

  // The relative height of topListView and bottomListView
  final int topListViewFlex = 11;
  final int bottomListViewFlex = 101;


  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: addFriendViewHeight,
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
                          decoration:  InputDecoration(
                            hintText: 'Search by Email',
                            contentPadding: const EdgeInsets.all(20),
                            suffixIcon: IconButton(
                              onPressed:  () async {
                                searchedUserInfoList = await Firestore.getUserInfoFromEmail(_searchBarController.text);
                                setState(() {
                                });
                                print('Add friend view get UserInfoList, length:' + searchedUserInfoList.length.toString());
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
                    itemBuilder: (context, index)
                    {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage
                            (
                            searchedUserInfoList.elementAt(index).photoURL!
                              ),
                        ),
                        title: Text(
                          searchedUserInfoList.elementAt(index).displayName!,
                        ),
                        subtitle: Text(
                          searchedUserInfoList.elementAt(index).email!,
                        ),
                      );
                    }
                    ,
                  )),
            ],
          ),
        ));
  }
  
}