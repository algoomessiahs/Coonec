import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/group_model.dart';
import '../../Screens/Chat/Matches.dart';
import '../../Screens/Chat/groupchatPage.dart';
import '../../models/user_model.dart';
import '../../util/color.dart';
import 'package:intl/intl.dart';

class GroupRecentChats extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  final AUser currentUser;
  final List<GroupModel> groups;
  //final GroupModel currentGroup;

  GroupRecentChats(this.currentUser, this.groups);

  @override
  Widget build(BuildContext context) {
    return groups.length == 0 ? 

Container(
  margin: EdgeInsets.only(top: 170),
child: Center(
                      child: Text(
                      "You have no Group Chats yet!",
                      style: TextStyle(color: secondryColor, fontSize: 20),
                    ))
)
    
    : Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: ListView.builder(
                physics: ScrollPhysics(),

                itemCount: groups.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => GroupChatPage(
                                    groupchatId: groups[i].id,
                                    sender: currentUser,
                                    currentGroup: groups[i],
                                  ),
                                ),
                              ),
                              child: StreamBuilder(
                                  stream: db
                                      .collection("groupchats")
                                      .doc(groups[i].id)
                                      .collection('messages')
                                      .orderBy('time', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      );
                                    else if (snapshot.data.docs.length == 0) {
                                      return Container();
                                    }
              
                                    return Container(
                                      margin: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0, right: 20.0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: secondryColor.withOpacity(.2),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: secondryColor,
                                          radius: 30.0,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                            child: Image.network(groups[i].image != null || groups[i].image != "" ? groups[i].image : "https://www.iedunote.com/img/28051/reference-groups.jpg",),
                                        ),
                                        ),
                                        title: Text(
                                          groups[i].name,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          snapshot.data.docs[0]['image_url']
                                                      .toString()
                                                      .length >
                                                  0
                                              ? "Photo"
                                              : snapshot.data.docs[0]
                                                  ['text'],
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.docs[0]
                                                          ["time"] !=
                                                      null
                                                  ? DateFormat.H()
                                                      .add_jm()
                                                      .format(snapshot.data.docs[0]["time"].toDate())
                                                      .toString().substring(2)
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            snapshot.data.docs[0]
                                                            ['sender_id'] !=
                                                        currentUser.id &&
                                                    !snapshot.data.docs[0]
                                                        ['isRead']
                                                ? Container(
                                                    width: 40.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'NEW',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : Text(""),
                                            snapshot.data.docs[0]
                                                        ['sender_id'] ==
                                                    currentUser.id
                                                ? !snapshot.data.docs[0]
                                                        ['isRead']
                                                    ? Icon(
                                                        Icons.done,
                                                        color: secondryColor,
                                                        size: 15,
                                                      )
                                                    : Icon(
                                                        Icons.done_all,
                                                        color: primaryColor,
                                                        size: 15,
                                                      )
                                                : Text("")
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                 );
                },
              )
            )
            ));
  }
}
