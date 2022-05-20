import 'package:etoet/views/friend/DummyFriends/dummy_friend.dart';
import 'package:etoet/views/friend/widget/friend_view_widgets.dart';
import 'package:flutter/material.dart';

class FriendView extends StatelessWidget {
  const FriendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
        controller: ScrollController(),
        physics: const ScrollPhysics(parent: PageScrollPhysics()),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const FriendAppBar(),
          ];
        },
        // body: ShowFriendCards(),
        body: Container(
        var dummyFriend = DummyFriend();


        )
      ),
    );
  }
}

class FriendAppBar extends StatelessWidget {
  const FriendAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: FriendAppBarDelegate(),
    );
  }
}

// The app bar of Friend View
class FriendAppBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, shrinkOffset, bo) {
    return Container(
      color: Colors.orange,
      height: 200,
      // color: Theme.of(context).primaryColorDark,
      child: SafeArea(
        child: Container(
            margin: EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 233, 164, 61),
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Search',
                  ),
                    onChanged: searchFriend,
                  ),
                ),
                AddFriendButton(),
              ],
            )),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 150;

  @override
  // TODO: implement minExtent
  double get minExtent => 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }

  void searchFriend(String query)
  {
    DummyFriend dummyFriend = DummyFriend();
    dummyFriend.testFunc();
    var allFriends = dummyFriend.friendList;

    final suggestions = allFriends.where((friend) {
      final friendName = friend.displayName!;
      final input = query;

      return friendName.contains(input);
    }).toList();

  }

}
