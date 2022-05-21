import 'package:etoet/views/friend/dummyUsers.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FriendView extends StatefulWidget {
  @override
  const FriendView({Key? key}) : super(key: key);

  @override
  _FriendViewState createState() => _FriendViewState();
}

class _FriendViewState extends State<FriendView> {

  //Dummy users for displaying friends in Friend List:
  DummyUser dummyUser = DummyUser();
  List<String>? userDisplayNameList = [];
  List<String>? userDisplayNameListOnSearch = [];

  //A list of ListTile to display Friends.
  //final userListWidget = <Widget>[];

  //IDK what this does, but it belongs to search function
  var _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < dummyUser.userList.length; ++i) {
      userDisplayNameList!.add(dummyUser.userList
          .elementAt(i)
          .displayName!);
    }


  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          child: Column(
            children: [
              // Search and Add Friend
              Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.orangeAccent,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            contentPadding: EdgeInsets.all(20),
                            suffixIcon: IconButton(
                              onPressed: ()
                                {
                                  if(_textEditingController!=null)
                                    {
                                      _textEditingController.clear();
                                    }
                                },
                              icon: Icon(Icons.clear),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {

                              List<String>? placeholder = [];
                              for(int i = 0; i < userDisplayNameList!.length; ++i)
                                {

                                  if(userDisplayNameList!.elementAt(i).toLowerCase().contains(value.toLowerCase()))
                                    {
                                      placeholder.add(userDisplayNameList!.elementAt(i));
                                    }
                                }
                              userDisplayNameListOnSearch = placeholder;
                            });

                          },
                        ),
                        const ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.add),
                          ),
                          title: Text('Add Friend'),
                        ),
                      ],
                    ),
                  )),

              // Friend List
              Expanded(
                  flex: 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    // children: userListWidget,
                    itemCount: _textEditingController.text.isNotEmpty? userDisplayNameListOnSearch!.length : userDisplayNameList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://i.guim.co.uk/img/media/26392d05302e02f7bf4eb143bb84c8097d09144b/446_167_3683_2210/master/3683.jpg?width=1200&height=1200&quality=85&auto=format&fit=crop&s=49ed3252c0b2ffb49cf8b508892e452d'),
                        ),
                        title: Text(_textEditingController.text.isNotEmpty? userDisplayNameListOnSearch!.elementAt(index) : userDisplayNameList!.elementAt(index)),
                        subtitle: const Text('Status text here.'),
                      );
                    },
                  )),
            ],
          ),
        ));
  }
}
