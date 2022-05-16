// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:etoet/views/friend/search_friend_view.dart';
import 'package:etoet/views/friend/widget/friend_view_widgets.dart';
import 'package:flutter/material.dart';

class FriendView extends StatefulWidget {
  const FriendView({Key? key}) : super(key: key);

  @override
  State<FriendView> createState() => _FriendState();
}

class _FriendState extends State<FriendView> {
  var _searchedTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Friends')),
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(15),
                child:
                    SearchBar(searchedTextController: _searchedTextController)),
            const AddFriendButton(),
            const ShowFriends(),
          ],
        ));
  }
}
