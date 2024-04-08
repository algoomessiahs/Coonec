import 'dart:math';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/models/group_model.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Screens/Chat/largeImage.dart';
import '../../Screens/Information.dart';
import '../../Screens/reportUser.dart';
import '../../models/user_model.dart';
import '../../util/color.dart';
import '../../util/snackbar.dart';
import 'package:intl/intl.dart';


class GroupChatPage extends StatefulWidget {
  final AUser sender;
  final String groupchatId;
  final GroupModel currentGroup;

  final String groupName;

  //final User second;
  GroupChatPage({this.sender, this.groupchatId, @required this.currentGroup, this.groupName});
  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final db = FirebaseFirestore.instance;
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  //adsf Ads _ads = new Ads();

  CollectionReference usersReference;
  AUser otherUser;

  @override
  void initState() {
    //adsf _ads.myInterstitial()..load()..show();
    print("object    -${widget.groupchatId}");
    super.initState();
    chatReference =
        db.collection("groupchats").doc(widget.groupchatId).collection('messages');

    usersReference  = db.collection("Users");
    FirebaseFirestore.instance
    .collection('Users/${widget.sender.id}')
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            print(doc["age"]);
        });
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
                                // CachedNetworkImage(
                                //   placeholder: (context, url) => Center(
                                //     child: CupertinoActivityIndicator(
                                //       radius: 10,
                                //     ),
                                //   ),
                                //   errorWidget: (context, url, error) =>
                                //       Icon(Icons.error),
                                //   height: MediaQuery.of(context).size.height * .65,
                                //   width: MediaQuery.of(context).size.width * .9,
                                //   imageUrl:
                                //       documentSnapshot.data()['image_url'] ?? '',
                                //   fit: BoxFit.fitWidth,
                                // ),
                                Image(
                                  image: NetworkImage(documentSnapshot.data()['image_url'] ?? ''),
                                  width: MediaQuery.of(context).size.width * .9,
                                  height: MediaQuery.of(context).size.height * .65,
                                  fit: BoxFit.fitWidth,
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
                  : documentSnapshot.data()['text'] != " Group  Created " ? Container(
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
                      ))



                      :



                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                    child: Text(
                                      documentSnapshot.data()['text'],
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    documentSnapshot.data()["time"] != null
                                        ? "On " + DateFormat.MMMd()
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
                        ),
                      ),







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
            documentSnapshot.data()['sender_imageUrl'] == '' ? Container() : Container(
              margin: EdgeInsets.only(right: 5),

              child: InkWell(
                child: CircleAvatar(
                  backgroundColor: secondryColor,
                  radius: 25.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    // child: CachedNetworkImage(
                    //   imageUrl: documentSnapshot.data()['sender_imageUrl'],
                    //   //imageUrl: snapshot.data()['Pictures'[0]] ?? '',
                    //   useOldImageOnUrlChange: true,
                    //   placeholder: (context, url) => CupertinoActivityIndicator(
                    //     radius: 15,
                    //   ),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    // ),
                    child: FadeInImage(
                      placeholder: AssetImage("asset/user.png"),
                      image: NetworkImage(documentSnapshot.data()['sender_imageUrl']),
                    ),
                  ),
                ),

              // onTap: () => showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (context) {
              //       return Info(widget.sender, widget.sender, null);
              //     }),

              ),
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
                            // child: CachedNetworkImage(
                            //   placeholder: (context, url) => Center(
                            //     child: CupertinoActivityIndicator(
                            //       radius: 10,
                            //     ),
                            //   ),
                            //   errorWidget: (context, url, error) =>
                            //       Icon(Icons.error),
                            //   height: MediaQuery.of(context).size.height * .65,
                            //   width: MediaQuery.of(context).size.width * .9,
                            //   imageUrl:
                            //       documentSnapshot.data()['image_url'] ?? '',
                            //   fit: BoxFit.fitWidth,
                            // ),
                            child: Image(
                              image: NetworkImage(documentSnapshot.data()['image_url'] ?? ''),
                              height: MediaQuery.of(context).size.height * .65,
                              width: MediaQuery.of(context).size.width * .9,
                              fit: BoxFit.fitWidth,
                            ),
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


                  : 
                  documentSnapshot.data()['sender_imageUrl'] != '' ? Container(
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
                      )) 

                      :

                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                    child: Text(
                                      documentSnapshot.data()['text'],
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    documentSnapshot.data()["time"] != null
                                        ? "On " + DateFormat.MMMd()
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
                        ),
                      ),


            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    // if (!documentSnapshot.data()['isRead']) {
    //   chatReference.doc(documentSnapshot.id).updateData({
    //     'isRead': true,
    //   });

    //   return _messagesIsRead(documentSnapshot);
    // }
    return _messagesIsRead(documentSnapshot);
  }

  generateMessages(AsyncSnapshot<QuerySnapshot <Map<String, dynamic>> > snapshot) {
    return snapshot.data.docs
        .map<Widget>((doc) => 
        Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: doc.data()['sender_id'] != widget.sender.id
                          ? generateReceiverLayout(
                              doc,
                            )
                          : generateSenderLayout(doc)),
            ),
            )
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
            backgroundImage: NetworkImage(widget.currentGroup.image != null || widget.currentGroup.image != "" ? widget.currentGroup.image : "https://www.iedunote.com/img/28051/reference-groups.jpg"),
            backgroundColor: Colors.grey,
          ),
          SizedBox(width: 20 * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //"iHateThis",
                widget.groupName != null ? widget.groupName : widget.currentGroup != null ? widget.currentGroup.name : "Group Name",
                style: TextStyle(fontSize: 16),
              ),

            ],
          )
        ],
      ),

      actions: [
        widget.currentGroup == null ? Container() : widget.sender.id == widget.currentGroup.leader ? IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            return showDialog(
    context: context,
   // barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Use the following group id to invite other people to group'),
        content: SingleChildScrollView(
          child: InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(
                      text: widget.currentGroup.id,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Group Id Copied!'),)
                    );
            },
            child: Text(
              widget.currentGroup == null ? "aed556" : widget.currentGroup.id
              ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
        ) : Container(),

      ],

    ),


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
                    stream: chatReference.orderBy('time', descending: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    child: _buildTextComposer(),
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
    return IconTheme(
        data: IconThemeData(color: _isWritting ? primaryColor : secondryColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  maxLines: 15,
                  minLines: 1,
                  autofocus: false,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.trim().length > 0;
                    });
                  },
                  decoration: InputDecoration.collapsed(
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
      'sender_imageUrl': widget.sender.imageUrl[0],
      'receiver_group_id': widget.groupchatId,
      'isRead': false,
      'image_url': '',
      'time': FieldValue.serverTimestamp(),
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }
}
