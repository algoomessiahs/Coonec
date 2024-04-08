// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Screens/Chat/chatPage.dart';
import '../../models/user_model.dart';
import '../../util/color.dart';

class Matches extends StatelessWidget {
  final AUser currentUser;
  final List<AUser> matches;

  Matches(this.currentUser, this.matches);

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
                  'New Matches',
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
              child: matches.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: matches.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ChatPage(
                                sender: currentUser,
                                chatId: chatId(currentUser, matches[index]),
                                second: matches[index],
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: secondryColor,
                                  radius: 35.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Image.network(matches[index].imageUrl[0] ?? ''),
                                  ),
                                ),
                                SizedBox(height: 6.0),
                                Text(
                                  matches[index].name,
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
                      "You have no matches :(",
                      style: TextStyle(color: secondryColor, fontSize: 16),
                    ))
                    ),
        ],
      ),
    );
  }
}

var groupChatId;
chatId(currentUser, sender) {
  if (currentUser.id.hashCode <= sender.id.hashCode) {
    return groupChatId = '${currentUser.id}-${sender.id}';
  } else {
    return groupChatId = '${sender.id}-${currentUser.id}';
  }
}
