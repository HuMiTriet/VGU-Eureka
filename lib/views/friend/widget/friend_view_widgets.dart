// ignore_for_file: prefer_const_constructors
import 'package:etoet/views/friend/DummyFriends/dummy_friend.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../add_friend_view.dart';



class FriendItem extends StatelessWidget {
  const FriendItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=49ed3252c0b2ffb49cf8b508892e452d'),
        ),
        title: Text('Dummy Name'),
        subtitle: Text('\$ multual friends'),
      ),
    );
  }
}

class AddFriendButton extends StatelessWidget {
  const AddFriendButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {

        },
        child: Row(children: const [
          CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10),
          Text('Add Friend')
        ]));
  }
}

class ShowFriendCards extends StatelessWidget {
  const ShowFriendCards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dummyFriend = DummyFriend();
    dummyFriend.testFunc();
    final friendChildren = <Widget>[];
    for(var i = 0; i < dummyFriend.friendList.length; ++i)
    {
        friendChildren.add(Card(
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=49ed3252c0b2ffb49cf8b508892e452d'),
            ),
            title: Text(dummyFriend.friendList.elementAt(i).displayName!),
            subtitle: Text('\$ multual friends'),
          ),
        ));
    }

    return ListView(
      children: friendChildren,
    );
  }
}
