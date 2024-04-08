import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/Screens/forum/forum.dart';
import 'package:flutter/material.dart';

import '../../Screens/Chat/groupchatPage.dart';
import '../../models/group_model.dart';
import '../new/cjgroup.dart';
import '../../Screens/Chat/recent_chats.dart';
import '../../Screens/Chat/recent_groupchats.dart';
import '../../models/user_model.dart';
import '../../util/color.dart';
import 'Matches.dart';

class HomeScreen extends StatefulWidget {
  final AUser currentUser;
  final List<AUser> matches;
  final List<AUser> newmatches;

  HomeScreen(this.currentUser, this.matches, this.newmatches);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGroup = false;

  // GroupModel currentGroup;
  List<GroupModel> groups;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (widget.matches.length > 0 && widget.matches[0].lastmsg != null) {
        widget.matches.sort((a, b) {
          var adate = a.lastmsg; //before -> var adate = a.expiry;
          var bdate = b.lastmsg; //before -> var bdate = b.expiry;
          return bdate?.compareTo(
              adate); //to get the order other way just switch `adate & bdate`
        });
        setState(() {});
      }
    });
    super.initState();

    // _getCurrentGroup();
    //_getCurrentGroups();
    _getUserGroups();
  }

  // _getCurrentGroup() async {
  //   try {
  //     return FirebaseFirestore.instance.collection("Groups").doc(widget.currentUser.groupIds).snapshots().listen((data) async {
  //       currentGroup = GroupModel.fromDocument(data);
  //       if (mounted) setState(() {});

  //       return currentGroup;
  //     });
  //   }catch(e){
  //     print("_getCurrentGroup ${e.toString()}");
  //   }
  // }

  // Future<bool> _getCurrentGroups() async {
  //   try {
  //      FirebaseFirestore.instance
  //         .collection('Groups')
  //         .orderBy('groupCreated', descending: true)
  //         .snapshots()
  //         .listen((ondata) {
  //       //groups.clear();
  //       if (ondatadocs.length > 0) {
  //         groups = [];
  //         ondatadocs.forEach((f) async {
  //           // DocumentSnapshot doc = await FirebaseFirestore.instance.doc(f.data()['Groups']).get();
  //           // print(doc);
  //           if (f.exists) {
  //             GroupModel tempGroupp = GroupModel.fromDocument(f);
  //             print(tempGroupp);
  //             print("===T==E==S==>" + tempGroupp.name);
  //             groups.add(tempGroupp);
  //           }
  //         });
  //       }
  //     });

  //      //if (mounted) setState(() {});
  //      return true;

  //   } catch (e) {
  //     print("_getCurrentGroup ${e.toString()}");
  //     return false;
  //   }
  // }

  Future<bool> _getUserGroups() async {
    try {
       FirebaseFirestore.instance
          .collection('Groups')
          .orderBy('groupCreated', descending: true)
          .snapshots()
          .listen((ondata) {
        //groups.clear();
        if (ondata.docs.length > 0) {
          groups = [];
          ondata.docs.forEach((f) async {
            // print(doc);
            if (f.exists) {
              GroupModel tempGroupp = GroupModel.fromDocument(f);
              //print("===T==E==S==>" + tempGroupp.name);
              for(int i=0; i<ondata.docs.length; i++) {
                if (tempGroupp.id == widget.currentUser.groupIds[i]) {
                  groups.add(tempGroupp);
                }
              }
              //groups.add(tempGroupp);
            }
          });
        }
      });

       //if (mounted) setState(() {});
       return true;

    } catch (e) {
      print("_getCurrentGroup ${e.toString()}");
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return !isGroup
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isGroup = !isGroup;
                });
              },
              backgroundColor: Colors.lightBlueAccent,
              tooltip: "Switch Chat Mode",
              child: Icon(Icons.switch_left),
            ),
            backgroundColor: primaryColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Chats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Forumn()));
                      },
                      child: Text(
                      'Discussion',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                                      ),
                    ),
                ],
              ),
              elevation: 0.0,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(50),
                      // topRight: Radius.circular(50)),
                  color: Colors.white),
              child: ClipRRect(
                // borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(50),
                //     topRight: Radius.circular(50)),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Matches(widget.currentUser, widget.newmatches),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(26),
                        child: Text(
                          'Recent Chats',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      RecentChats(widget.currentUser, widget.matches),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Cjgroup(groups))
                              );
                    },
                    backgroundColor: Colors.green,
                    tooltip: "Create / Join Group",
                    child: Icon(Icons.add),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        isGroup = !isGroup;
                      });
                    },
                    backgroundColor: Colors.lightBlueAccent,
                    tooltip: "Switch Chat Mode",
                    child: Icon(Icons.switch_right),
                  )
                ],
              ),
            ),
            backgroundColor: primaryColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
              title: Text(
                'Your Group Chats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              elevation: 0.0,
            ),
            body: FutureBuilder<bool>(
                //future: _getCurrentGroups(),
                future: _getUserGroups(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done)
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50)),
                          color: Colors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Matches(widget.currentUser, widget.newmatches),
                              //Divider(),
                              Padding(
                                padding: const EdgeInsets.all(26),
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => GroupChatPage(
                                    //               sender: widget.currentUser,
                                    //               groupchatId: widget
                                    //                   .currentUser.groupIds[0],
                                    //               currentGroup: groups[0],
                                    //             )));
                                  },
                                  child: Text(
                                    'Group Chats',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              GroupRecentChats(
                                widget.currentUser,
                                groups,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  else
                    return Container(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    );
                }),
          );
  }
}
