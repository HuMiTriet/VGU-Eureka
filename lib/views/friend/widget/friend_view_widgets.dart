// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

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
        onPressed: () {},
        child: Row(children: const [
          CircleAvatar(
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10),
          Text('Add Friend')
        ]));
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required TextEditingController searchedTextController,
  })  : _searchedTextController = searchedTextController,
        super(key: key);

  final TextEditingController _searchedTextController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchedTextController,
      decoration: InputDecoration(
        fillColor: Color.fromARGB(255, 238, 235, 227),
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        // errorBorder: InputBorder.none,
        // focusedBorder: InputBorder.none,
        // enabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.all(15),
        filled: true,
        hintText: 'Search',
      ),
      enabled: true,
    );
  }
}

class ShowFriends extends StatelessWidget {
  const ShowFriends({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: ScrollPhysics(parent: null),
        shrinkWrap: true,
        itemCount: 15,
        itemBuilder: (context, index) {
          return const FriendItem();
        },
      ),
    );
  }
}
