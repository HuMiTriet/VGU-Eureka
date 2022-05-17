import 'package:etoet/views/friend/widget/friend_view_widgets.dart';
import 'package:flutter/material.dart';

class FriendView extends StatelessWidget {
  const FriendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: NestedScrollView(
        controller: ScrollController(),
        physics: ScrollPhysics(parent: PageScrollPhysics()),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CustomAppBar(),
          ];
        },
        body: ShowFriends(),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MyAppBarDelegate(),
    );
  }
}

class MyAppBarDelegate extends SliverPersistentHeaderDelegate {
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 233, 164, 61),
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Search',
                  )),
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
}
