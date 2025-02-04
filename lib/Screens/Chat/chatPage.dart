import 'dart:math';
import 'dart:io';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../Screens/Chat/largeImage.dart';
import '../../Screens/Information.dart';
import '../../Screens/reportUser.dart';
import '../../ads/ads.dart';
import '../../models/user_model.dart';
import '../../util/color.dart';
import '../../util/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Calling/dial.dart';

class ChatPage extends StatefulWidget {
  final AUser sender;
  final String chatId;
  final AUser second;
  ChatPage({this.sender, this.chatId, this.second});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isBlocked = false;
  final db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //adsf Ads _ads = new Ads();

  @override
  void initState() {
    //adsf _ads.myInterstitial()..load()..show();
    print("object    -${widget.chatId}");
    super.initState();
    chatReference =
        db.collection("chats").doc(widget.chatId).collection('messages');
    checkblock();
  }

  var blockedBy;
  checkblock() {
    chatReference.doc('blocked').snapshots().listen((onData) {
      if (onData.data != null) {
        blockedBy = onData.data()['blockedBy'];
        if (onData.data()['isBlocked']) {
          isBlocked = true;
        } else {
          isBlocked = false;
        }

        if (mounted) setState(() {});
      }
      // print(onData.data()['blockedBy']);
    });
  }

  List<Widget> generateSenderLayout(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              child: documentSnapshot.data()['image_url'] != ''
                  ? InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(
                                top: 2.0, bottom: 2.0, right: 15),
                            child: Stack(
                              children: <Widget>[
                                Image.network(
                                  documentSnapshot.data()['image_url'] ?? '',
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child:
                                      documentSnapshot.data()['isRead'] == false
                                          ? Icon(
                                              Icons.done,
                                              color: secondryColor,
                                              size: 15,
                                            )
                                          : Icon(
                                              Icons.done_all,
                                              color: primaryColor,
                                              size: 15,
                                            ),
                                )
                              ],
                            ),
                            height: 150,
                            width: 150.0,
                            color: secondryColor.withOpacity(.5),
                            padding: EdgeInsets.all(5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                                documentSnapshot.data()["time"] != null
                                    ? DateFormat.yMMMd()
                                        .add_jm()
                                        .format(documentSnapshot.data()["time"]
                                            .toDate())
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                )),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => LargeImage(
                              documentSnapshot.data()['image_url'],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      margin: EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 80.0, right: 10),
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Text(
                                    documentSnapshot.data()['text'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    documentSnapshot.data()["time"] != null
                                        ? DateFormat.MMMd()
                                            .add_jm()
                                            .format(documentSnapshot
                                                .data()["time"]
                                                .toDate())
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                      color: secondryColor,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  documentSnapshot.data()['isRead'] == false
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
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    ];
  }

  _messagesIsRead(documentSnapshot) {
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: CircleAvatar(
              backgroundColor: secondryColor,
              radius: 25.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: Image.network(widget.second.imageUrl[0] ?? ''),
              ),
            ),
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return Info(widget.second, widget.sender, null);
                });
            }
          ),
        ],
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: documentSnapshot.data()['image_url'] != ''
                  ? InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(
                                top: 2.0, bottom: 2.0, right: 15),
                            child: Image.network(documentSnapshot.data()['image_url'] ?? '',),
                            height: 150,
                            width: 150.0,
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            padding: EdgeInsets.all(5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                                documentSnapshot.data()["time"] != null
                                    ? DateFormat.yMMMd()
                                        .add_jm()
                                        .format(documentSnapshot.data()["time"]
                                            .toDate())
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                )),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => LargeImage(
                            documentSnapshot.data()['image_url'],
                          ),
                        ));
                      },
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10),
                      decoration: BoxDecoration(
                          color: secondryColor.withOpacity(.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Text(
                                    documentSnapshot.data()['text'],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    documentSnapshot.data()["time"] != null
                                        ? DateFormat.MMMd()
                                            .add_jm()
                                            .format(documentSnapshot
                                                .data()["time"]
                                                .toDate())
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                      color: secondryColor,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if (!documentSnapshot.data()['isRead']) {
      chatReference.doc(documentSnapshot.id).update({
        'isRead': true,
      });

      return _messagesIsRead(documentSnapshot);
    }
    return _messagesIsRead(documentSnapshot);
  }

  generateMessages(AsyncSnapshot<QuerySnapshot <Map<String, dynamic>> > snapshot) {
    return snapshot.data.docs
        .map<Widget>((doc) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: doc.data()['type'] == "Call"
                      ? [
                          Text(doc.data()["time"] != null
                              ? "${doc.data()['text']} : " +
                                  DateFormat.yMMMd()
                                      .add_jm()
                                      .format(doc.data()["time"].toDate())
                                      .toString() +
                                  " by ${doc.data()['sender_id'] == widget.sender.id ? "You" : "${widget.second.name}"}"
                              : "")
                        ]
                      : doc.data()['sender_id'] != widget.sender.id
                          ? generateReceiverLayout(
                              doc,
                            )
                          : generateSenderLayout(doc)),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: NetworkImage(widget.second.imageUrl[0]),
          ),
          SizedBox(width: 20 * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.second.name,
                style: TextStyle(fontSize: 16),
              ),

            ],
          )
        ],
      ),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.local_phone),
        //   onPressed: () {
        //    // onJoin("AudioCall");
        //   },
        // ),
        // IconButton(
        //   icon: Icon(Icons.videocam),
        //   onPressed: () {
        //    // onJoin("VideoCall");
        //   },
        // ),


            PopupMenuButton(itemBuilder: (ct) {
              return [
                PopupMenuItem(
                  value: 'value1',
                  child: InkWell(
                    onTap: () => showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => ReportUser(
                              currentUser: widget.sender,
                              seconduser: widget.second,
                            )).then((value) => Navigator.pop(ct)),
                    child: Container(
                        width: 100,
                        height: 30,
                        child: Text(
                          "Report",
                        )),
                  ),
                ),
                PopupMenuItem(
                  height: 30,
                  value: 'value2',
                  child: InkWell(
                    child: Text(isBlocked ? "Unblock user" : "Block user"),
                    onTap: () {
                      Navigator.pop(ct);
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: Text(isBlocked ? 'Unblock' : 'Block'),
                            content: Text(
                                'Do you want to ${isBlocked ? 'Unblock' : 'Block'} ${widget.second.name}?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('No'),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  Navigator.pop(ctx);
                                  if (isBlocked &&
                                      blockedBy == widget.sender.id) {
                                    chatReference.doc('blocked').set({
                                      'isBlocked': !isBlocked,
                                      'blockedBy': widget.sender.id,
                                    });
                                  } else if (!isBlocked) {
                                    chatReference.doc('blocked').set({
                                      'isBlocked': !isBlocked,
                                      'blockedBy': widget.sender.id,
                                    });
                                  } else {
                                    CustomSnackbar.snackbar(
                                        "You can't unblock", _scaffoldKey);
                                  }
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              ];
            }),



        //SizedBox(width: 20 / 2),
      ],
    ),


      // appBar: AppBar(
      //     centerTitle: true,
      //     elevation: 0,
      //     title: Text(widget.second.name),
      //     leading: IconButton(
      //       icon: Icon(Icons.arrow_back_ios),
      //       color: Colors.white,
      //       onPressed: () => Navigator.pop(context),
      //     ),
      //     actions: <Widget>[
      //       IconButton(
      //           icon: Icon(Icons.call), onPressed: () => onJoin("AudioCall")),
      //       IconButton(
      //           icon: Icon(Icons.video_call),
      //           onPressed: () => onJoin("VideoCall")),
      //       PopupMenuButton(itemBuilder: (ct) {
      //         return [
      //           PopupMenuItem(
      //             value: 'value1',
      //             child: InkWell(
      //               onTap: () => showDialog(
      //                   barrierDismissible: true,
      //                   context: context,
      //                   builder: (context) => ReportUser(
      //                         currentUser: widget.sender,
      //                         seconduser: widget.second,
      //                       )).then((value) => Navigator.pop(ct)),
      //               child: Container(
      //                   width: 100,
      //                   height: 30,
      //                   child: Text(
      //                     "Report",
      //                   )),
      //             ),
      //           ),
      //           PopupMenuItem(
      //             height: 30,
      //             value: 'value2',
      //             child: InkWell(
      //               child: Text(isBlocked ? "Unblock user" : "Block user"),
      //               onTap: () {
      //                 Navigator.pop(ct);
      //                 showDialog(
      //                   context: context,
      //                   builder: (BuildContext ctx) {
      //                     return AlertDialog(
      //                       title: Text(isBlocked ? 'Unblock' : 'Block'),
      //                       content: Text(
      //                           'Do you want to ${isBlocked ? 'Unblock' : 'Block'} ${widget.second.name}?'),
      //                       actions: <Widget>[
      //                         FlatButton(
      //                           onPressed: () =>
      //                               Navigator.of(context).pop(false),
      //                           child: Text('No'),
      //                         ),
      //                         FlatButton(
      //                           onPressed: () async {
      //                             Navigator.pop(ctx);
      //                             if (isBlocked &&
      //                                 blockedBy == widget.sender.id) {
      //                               chatReference.doc('blocked').set({
      //                                 'isBlocked': !isBlocked,
      //                                 'blockedBy': widget.sender.id,
      //                               });
      //                             } else if (!isBlocked) {
      //                               chatReference.doc('blocked').set({
      //                                 'isBlocked': !isBlocked,
      //                                 'blockedBy': widget.sender.id,
      //                               });
      //                             } else {
      //                               CustomSnackbar.snackbar(
      //                                   "You can't unblock", _scaffoldKey);
      //                             }
      //                           },
      //                           child: Text('Yes'),
      //                         ),
      //                       ],
      //                     );
      //                   },
      //                 );
      //               },
      //             ),
      //           )
      //         ];
      //       })
      //     ]),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: primaryColor,
          body: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                  // image: DecorationImage(
                  //     fit: BoxFit.fitWidth,
                  //     image: AssetImage("asset/chat.jpg")),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: chatReference
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor),
                            strokeWidth: 2,
                          ),
                        );
                      return Expanded(
                        child: ListView(
                          reverse: true,
                          children: generateMessages(snapshot),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1.0),
                  Container(
                    alignment: Alignment.bottomCenter,
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    child: isBlocked
                        ? Text("Sorry You can't send message!")
                        : _buildTextComposer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDefaultSendButton() {
    return IconButton(
      icon: Transform.rotate(
        angle: -pi / 9,
        child: Icon(
          Icons.send,
          size: 25,
        ),
      ),
      color: primaryColor,
      onPressed: _isWritting
          ? () => _sendText(_textController.text.trimRight())
          : null,
    );
  }

  Widget _buildTextComposer() {
    ImagePicker picker = ImagePicker();
    return IconTheme(
        data: IconThemeData(color: _isWritting ? primaryColor : secondryColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                    icon: Icon(
                      Icons.photo_camera,
                      color: primaryColor,
                    ),
                    onPressed: () async {
                      var image = await picker.pickImage(source: ImageSource.gallery);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      Reference storageReference = FirebaseStorage.instance.ref().child('chats/${widget.chatId}/img_' +timestamp.toString() +'.jpg');
                      UploadTask uploadTask = storageReference.putFile(File(image.path));
                      await uploadTask.whenComplete(() async {
                        String fileUrl = await storageReference.getDownloadURL();
                        _sendImage(messageText: 'Photo', imageUrl: fileUrl);
                      });
                    
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  maxLines: 15,
                  minLines: 1,
                  autofocus: false,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.trim().length > 0;
                    });
                  },
                  decoration: new InputDecoration.collapsed(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(18)),
                      hintText: "Send a message..."),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _sendText(String text) async {
    _textController.clear();
    chatReference.add({
      'type': 'Msg',
      'text': text,
      'sender_id': widget.sender.id,
      'receiver_id': widget.second.id,
      'isRead': false,
      'image_url': '',
      'time': FieldValue.serverTimestamp(),
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }

  void _sendImage({String messageText, String imageUrl}) {
    chatReference.add({
      'type': 'Image',
      'text': messageText,
      'sender_id': widget.sender.id,
      'receiver_id': widget.second.id,
      'isRead': false,
      'image_url': imageUrl,
      'time': FieldValue.serverTimestamp(),
    });
  }

  // Future<void> onJoin(callType) async {
  //   if (!isBlocked) {
  //     // await for camera and mic permissions before pushing video page

  //     await handleCameraAndMic(callType);
  //     await chatReference.add({
  //       'type': 'Call',
  //       'text': callType,
  //       'sender_id': widget.sender.id,
  //       'receiver_id': widget.second.id,
  //       'isRead': false,
  //       'image_url': "",
  //       'time': FieldValue.serverTimestamp(),
  //     });

  //     // push video page with given channel name
  //     // await Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (context) => DialCall(
  //     //         channelName: widget.chatId,
  //     //         receiver: widget.second,
  //     //         callType: callType),
  //     //   ),
  //     // );
  //     // Fuck
  //   } else {
  //     CustomSnackbar.snackbar("Blocked !", _scaffoldKey);
  //   }
  // }

}

Future<void> handleCameraAndMic(callType) async {
  // await PermissionHandler().requestPermissions(
  //   callType == "VideoCall"
  //     ? [PermissionGroup.camera, PermissionGroup.microphone]
  //     : [PermissionGroup.microphone]
  //     );

Map<Permission, PermissionStatus> statuses = callType == "VideoCall" ? await [
  Permission.location, 
  Permission.camera,
  //add more permission to request here.
].request() : await Permission.location.request();

}
