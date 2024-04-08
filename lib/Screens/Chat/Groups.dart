import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Screens/Chat/groupchatPage.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../util/color.dart';

class Groups extends StatelessWidget {
  final AUser currentUser;
  final List<GroupModel> groups;

  Groups(this.currentUser, this.groups);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'New Groups',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                  ),
                  iconSize: 30.0,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Container(
              height: 120.0,
              child: groups.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: groups.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                          //    Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (_) => GroupChatPage(
                          //       groupchatId: chatId(currentUser),
                          //       //groupName: groups[index].name,
                          //       sender: currentUser,
                          //       //currentGroup: groups[index],
                          //     ),
                          //   ),
                          // );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: secondryColor,
                                  radius: 35.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                SizedBox(height: 6.0),
                                Text(
                                  groups[index].name,
                                  style: TextStyle(
                                    color: secondryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                      "You are in no groups yet :(",
                      style: TextStyle(color: secondryColor, fontSize: 16),
                    ))),
        ],
      ),
    );
  }
}

var groupChatId;
chatId(currentUser) {
  return groupChatId = '${currentUser.id}';
}
