//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating/Screens/Information.dart';
import 'package:dating/models/user_model.dart';
import 'package:dating/util/color.dart';

import 'Tab.dart';

class Notifications extends StatefulWidget {
  final AUser currentUser;
  Notifications(this.currentUser);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final db = FirebaseFirestore.instance;
  CollectionReference matchReference;

  @override
  void initState() {
    matchReference = db.collection("Users").doc(widget.currentUser.id).collection('Matches');

    super.initState();
    // Future.delayed(Duration(seconds: 1), () {
    //   if (widget.notification.length > 1) {
    //     widget.notification.sort((a, b) {
    //       var adate = a.time; //before -> var adate = a.expiry;
    //       var bdate = b.time; //before -> var bdate = b.expiry;
    //       return bdate.compareTo(
    //           adate); //to get the order other way just switch `adate & bdate`
    //     });
    //   }
    // });
    // if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              color: Colors.white),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child: Text(
                //     'this week',
                //     style: TextStyle(
                //       color: primaryColor,
                //       fontSize: 18.0,
                //       fontWeight: FontWeight.bold,
                //       letterSpacing: 1.0,
                //     ),
                //   ),
                // ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: matchReference
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                            child: Text(
                          "No Notification",
                          style: TextStyle(color: secondryColor, fontSize: 16),
                        ));
                      else if (snapshot.data.docs.length == 0) {
                        return Center(
                            child: Text(
                          "No Notification",
                          style: TextStyle(color: secondryColor, fontSize: 16),
                        ));
                      }
                      return Expanded(
                        child: ListView(
                          children: snapshot.data.docs
                              .map((doc) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: !doc.data()['isRead'] ?
                                             primaryColor.withOpacity(.15) : 
                                             secondryColor.withOpacity(.15)),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(5),
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: secondryColor,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25,
                                              ),
                                              child: FadeInImage(
                                                image: NetworkImage(doc.data()['pictureUrl'] ?? ""),

                                                fit: BoxFit.cover,
                                                placeholder: AssetImage("asset/user.png"),
                                              ),
                                            ),
                                            // backgroundImage:
                                            //     NetworkImage(
                                            //   widget.notification[index]
                                            //       .sender.imageUrl[0],
                                            // )
                                          ),
                                          title: Text(
                                              "you are matched with ${doc.data()['userName'] ?? "__"}"),
                                          subtitle: Text(
                                              "${(doc.data()['timestamp'].toDate())}"),
                                          //  Text(
                                          //     "Now you can start chat with ${notification[index].sender.name}"),
                                          // "if you want to match your profile with ${notifications[index].sender.name} just like ${notifications[index].sender.name}'s profile"),
                                          trailing: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                !doc.data()['isRead']
                                                    ? Container(
                                                        width: 40.0,
                                                        height: 20.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
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
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            print(doc.data()["Matches"]);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ));
                                                });
                                            DocumentSnapshot userdoc = await db
                                                .collection("Users")
                                                .doc(doc.data()["Matches"])
                                                .get();
                                            if (userdoc.exists) {
                                              Navigator.pop(context);
                                              AUser tempuser =
                                                  AUser.fromDocument(userdoc.data());
                                              tempuser.distanceBW =
                                                  calculateDistance(
                                                          widget.currentUser
                                                                  .coordinates[
                                                              'latitude'],
                                                          widget.currentUser
                                                                  .coordinates[
                                                              'longitude'],
                                                          tempuser.coordinates[
                                                              'latitude'],
                                                          tempuser.coordinates[
                                                              'longitude'])
                                                      .round();

                                              await showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    if (!doc.data()["isRead"]) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "/Users/${widget.currentUser.id}/Matches")
                                                          .doc(
                                                              '${doc.data()["Matches"]}')
                                                          .update(
                                                              {'isRead': true});
                                                    }
                                                    return Info(
                                                        tempuser,
                                                        widget.currentUser,
                                                        null);
                                                  });
                                            }
                                          },
                                        )
                                        //  : Container()
                                        ),
                                  ))
                              .toList(),
                        ),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
