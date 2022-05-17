// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('url'),
        ),
        title: Text('Friend Name'),
        subtitle: Text('\$ multual friends'),
        // trailing: TextButton(
        //   onPressed: () {},
        //   child: Text('Add Friend'),
        // )
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
        onPressed: () => showDialog<void>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Add Friend By Phone Number'),
                content: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter phone number',
                    )),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
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

class ShowFriends extends StatelessWidget {
  const ShowFriends({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ModalScrollController.of(context),
      // physics: ScrollPhysics(parent: null),
      // shrinkWrap: true,
      itemCount: 15,
      itemBuilder: (context, index) {
        return const FriendItem();
      },
    );
  }
}
