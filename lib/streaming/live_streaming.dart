// import 'dart:async';

// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as localview;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as remoteview;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';


// import 'package:visionlive/constants/constants.dart';
// import 'package:visionlive/controllers/controllers.dart';
// import 'package:visionlive/functions/functions.dart';
// import 'package:visionlive/constants/agora_cofig.dart';
// import 'package:visionlive/model/models.dart';
// import 'package:visionlive/widgets/widgets.dart';
// import 'screens.dart';
// import 'streamtopview.dart';

// var defaultUid = 'cHvFVaDNcNT6dNrN61q5Apls1y72';

// class LiveStreaming extends StatefulWidget {
//   final ClientRole role;
//   final String channelName;
//   final String callType;
//   final ApplicationUser joinedUser;
//   final streamingId;
//   final _auth = FirebaseAuth.instance;
//   final UserStream oldStream;

//   LiveStreaming(this.oldStream,
//       {@required this.streamingId,
//       @required this.role,
//       @required this.channelName,
//       @required this.callType,
//       @required this.joinedUser});
//   @override
//   State<StatefulWidget> createState() => _State();
// }

// class _State extends State<LiveStreaming> {
//   static final _users = <int>[];
//   bool muted = false;
//   bool disable = true;
//   RtcEngine engine;
//   String callDoc;

//   ///this id is used to send gift to selected user on pk [battle]
//   String selectedUserId;
//   Stream<DocumentSnapshot<Map<String, dynamic>>> docStream;
//   final streamController = Get.find<UserStreamController>();
//   final _authController = Get.find<AuthController>();
//   final _auth = FirebaseAuth.instance;
//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> sub;
//   UserStream stream;
//   @override
//   void dispose() {
//     _users.clear();
//     sub?.cancel();
//     super.dispose();
//   }

//   disposeAll(bool ended, {bool reJoin = false}) async {
//     try {
//       await engine?.leaveChannel();
//       await engine?.destroy();
//     } catch (e) {}
//     if (widget.role == ClientRole.Broadcaster &&
//         widget.oldStream.streamer.uid == widget._auth.currentUser.uid) {
//       await streamController.endStream(widget.streamingId);
//       // if (!ended) {
//       //   return;
//       // }
//     } else if (widget.role == ClientRole.Audience) {
//       await streamController.joinOrLeaveStream(widget.streamingId, join: false);
//     } else {
//       //for other boradcaster;
//       streamController.addorRemoveBroadCaster(stream ?? widget.oldStream, myId,
//           remove: true);
//     }
//     if (widget.role == ClientRole.Audience && ended) {
//       Get.back(result: ended);
//       Get.to(() => StreamingEnded(
//             stream: widget.oldStream,
//           ));
//     } else {
//       if (widget.role == ClientRole.Audience && reJoin) {
//         return;
//       } else {
//         Get.back(
//           closeOverlays: true
//         );
//       }
//     }
//   }

//   int myId;
//   bool callEnded = false;
//   listenStreamEvent() async {
//     sub = FirebaseFirebaseFirestore.instance
//         .collection(FirebaseCollections.STREAMING_COLLECTIONS)
//         .doc(widget.streamingId)
//         .snapshots()
//         .listen((doc) {
//       if (doc.data != null) {
//         bool state = doc.data()['isStreaming'];

//         setState(() {
//           stream = UserStream.fromMap(doc.data(), doc.id);
//         });
//         if (!state && !callEnded) {
//           disposeAll(true);
//           callEnded = true;
//         }
//         if (doc.data()['ack'] == 1 &&
//             widget.role == ClientRole.Broadcaster &&
//             widget.oldStream.streamer.uid == widget._auth.currentUser.uid) {
//           streamController.ackBackToServer(widget.streamingId);
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.role == ClientRole.Broadcaster)
//       handleCameraAndMic(widget.callType);
//     initialize();
//     listenStreamEvent();
//     if (widget.role != ClientRole.Broadcaster) {
//       streamController.joinOrLeaveStream(widget.streamingId);
//     }
//     docStream = FirebaseFirebaseFirestore.instance
//         .collection(FirebaseCollections.STREAMING_COLLECTIONS)
//         .doc(widget.streamingId)
//         .snapshots();
//     streamController.micState.value = false;
//     streamController.showVideoStack.value = true;
//   }

//   Future<void> initialize() async {
//     await _initRtcEngine();
//     VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
//     await engine.setVideoEncoderConfiguration(configuration);
//     bool isPublisher = widget.role == ClientRole.Broadcaster ? true : false;
//     final token = await getToken(widget.channelName, isPublisher);
//     await engine?.joinChannel(token.token, widget.channelName, null, 0);
//   }

//   Future<void> _initRtcEngine() async {
//     engine = await RtcEngine.createWithConfig(RtcEngineConfig(APP_ID));
//     widget.callType == "Video"
//         ? await engine.enableVideo()
//         : await engine.enableAudio();

//     await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await engine.setClientRole(widget.role);
//     setState(() {});
//     _addListeners();
//   }

//   _addListeners() {
//     engine?.setEventHandler(RtcEngineEventHandler(
//       joinChannelSuccess: (channel, uid, ellapsed) {
//         if (!_authController.isLoggeIn) {
//           //  streamController.postComment(widget.streamingId, 'Joined live');
//         } else if (widget.role == ClientRole.Broadcaster &&
//             widget.oldStream.streamer.uid != _authController.currentUser.uid) {
//           streamController.postComment(widget.streamingId, 'Joined live');
//         } else if (widget.oldStream.streamer.uid !=
//             _authController.currentUser.uid) {
//           streamController.postComment(widget.streamingId, 'Joined live');
//         }
//         if (widget.role == ClientRole.Broadcaster &&
//             (widget.oldStream.allowMutiple || widget.oldStream.isPk)) {
//           streamController.addorRemoveBroadCaster(widget.oldStream, uid);
//         }

//         setState(() {
//           myId = uid;
//         });
//         //here we have to match firebase userid with agora uid to know whose uid corresponds to whom
//       },
//       userJoined: (uid, elapsed) {
//         _users.add(uid);
//         if (widget.callType == 'Audio') {
//           engine.setEnableSpeakerphone(true);
//         }
//         setState(() {});
//       },
//     ));
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       list.add(localview.SurfaceView());
//     }
//     _users.forEach((int uid) => list.add(remoteview.SurfaceView(uid: uid)));
//     return list;
//   }

//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   bool showRemoteLarge = true;
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[_videoView(views[0])],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow([views[0]]),
//             _expandedVideoRow([views[1]]),
//           ],
//         ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 2)),
//             _expandedVideoRow(views.sublist(2, 3))
//           ],
//         ));
//       case 4:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoRow(views.sublist(0, 1)),
//             _expandedVideoRow(views.sublist(2, 4))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }

//   void _onStreamEnd(BuildContext context) async {
//     disposeAll(false);
//   }

//   controlGuest(UserStream stream) {
//     if (widget.role == ClientRole.Broadcaster &&
//         stream.streamer.uid != _auth.currentUser.uid) {
//       engine.muteLocalAudioStream(!stream.allowFreeSpeak);
//       streamController.micState.value = !stream.allowFreeSpeak;
//     }
//     if (widget.role == ClientRole.Broadcaster) {
//       var myDoc = stream.members
//           .where((element) => element['uid'] == _auth.currentUser.uid)
//           .toList();
//       if (myDoc.length < 0) {
//         showSnackBar(
//           title: 'Alert',
//           body: 'You are removed from members',
//           color: Colors.redAccent,
//         );
//         disposeAll(false);
//       }
//     }
//   }

//   Widget multipleGuestView(bool video) {
//     return StreamBuilder(
//       stream: docStream,
//       builder:
//           (_, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//         if (snapshot.hasData) {
//           var stream =
//               UserStream.fromMap(snapshot.data.data(), snapshot.data.id);
//           List<LiveVideoModel> members =
//               stream.members.map((e) => LiveVideoModel.fromMap(e)).toList();
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             controlGuest(stream);
//           });
//           return Column(
//             children: [
//               SizedBox(
//                 height: 100,
//               ),
//               Expanded(
//                 child: GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: stream.maxAllow > 6 ? 3 : 2,
//                         mainAxisSpacing: 0.0,
//                         crossAxisSpacing: 0.0),
//                     itemCount: stream.maxAllow,
//                     itemBuilder: (_, index) {
//                       if (members.length > index) {
//                         var vm = members[index];
//                         return Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.yellowAccent),
//                           ),
//                           child: Stack(
//                             alignment: Alignment.bottomCenter,
//                             children: [
//                               if (!video)
//                                 Container(
//                                   alignment: Alignment.center,
//                                   child: Icon(
//                                     Icons.person,
//                                     size: 60,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                 ),
//                               if (video)
//                                 _auth.currentUser != null &&
//                                         vm.uid == _auth.currentUser.uid
//                                     ? localview.SurfaceView()
//                                     : remoteview.SurfaceView(uid: vm.videoId),
//                               Positioned(
//                                 bottom: 0,
//                                 left: 10,
//                                 child: Text(
//                                   vm.name,
//                                   style: TextStyle(color: Colors.yellow),
//                                 ),
//                               ),
//                               if (vm.uid == stream.channelName)
//                                 Positioned(
//                                   top: 2,
//                                   left: 2,
//                                   child: Container(
//                                     height: 18,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.grey),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 0.0, horizontal: 8),
//                                       child: Text(
//                                         'Host',
//                                         style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                             color: AppColors.PRIMARY_COLOR
//                                                 .withOpacity(0.8)),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         );
//                       }
//                       return Container(
//                         //  color: AppColors.PRIMARY_COLOR,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.yellowAccent)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 '${index + 1}',
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               ),
//                             ),
//                             Spacer(),
//                             Center(
//                               child: Builder(
//                                 builder: (context) => Container(
//                                   child: stream.roomMode ||
//                                           stream.streamer.uid ==
//                                               _auth.currentUser.uid
//                                       ? ActionRequireAuth(
//                                           child: Icon(Icons.add,
//                                               size: 30, color: Colors.white),
//                                           onPressed: () async {
//                                             if (widget.role ==
//                                                 ClientRole.Audience) {
//                                               disposeAll(
//                                                 false,
//                                                 reJoin: true,
//                                               );
//                                               Navigator.pushReplacement(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (_) =>
//                                                           LiveStreaming(
//                                                             stream,
//                                                             streamingId:
//                                                                 stream.docId,
//                                                             role: ClientRole
//                                                                 .Broadcaster,
//                                                             joinedUser:
//                                                                 _authController
//                                                                     .currentUser,
//                                                             callType:
//                                                                 stream.type,
//                                                             channelName: stream
//                                                                 .channelName,
//                                                           )));
//                                               //     Get.off(() => LiveStreaming(
//                                               //   stream,
//                                               //   streamingId: stream.docId,
//                                               //   role: ClientRole.Broadcaster,
//                                               //   joinedUser: _authController.currentUser,
//                                               //   callType: stream.type,
//                                               //   channelName: stream.channelName,
//                                               // ));
//                                             } else {
//                                               Scaffold.of(context)
//                                                   .showBottomSheet((context) =>
//                                                       Container(
//                                                           height: 400,
//                                                           child:
//                                                               DefaultTabController(
//                                                                   length: 3,
//                                                                   child: Column(
//                                                                     children: [
//                                                                       Container(
//                                                                         height:
//                                                                             50,
//                                                                         child:
//                                                                             TabBar(
//                                                                                 tabs: [
//                                                                           'Recents',
//                                                                           'Friends',
//                                                                           'Fans'
//                                                                         ]
//                                                                                     .map((e) => Text(
//                                                                                           e,
//                                                                                           style: TextStyle(color: Colors.black),
//                                                                                         ))
//                                                                                     .toList()),
//                                                                       ),
//                                                                       Expanded(
//                                                                         child:
//                                                                             TabBarView(
//                                                                           children: [
//                                                                             1,
//                                                                             2,
//                                                                             3
//                                                                           ]
//                                                                               .map((e) => FutureBuilder(
//                                                                                     future: FirebaseFirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).limit(10).get(),
//                                                                                     builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snashot) {
//                                                                                       if (snashot.hasData) {
//                                                                                         var users = snashot.data.docs.map((e) => ApplicationUser.fromMap(e.data(), e.id)).where((element) => element.uid != _auth.currentUser.uid).toList();
//                                                                                         return ListView.builder(
//                                                                                           itemCount: users.length,
//                                                                                           itemBuilder: (context, index) {
//                                                                                             var user = users[index];
//                                                                                             return Card(
//                                                                                               child: ListTile(
//                                                                                                   onTap: () async {
//                                                                                                     await FirebaseFirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).doc(user.uid).collection('notifications').add({
//                                                                                                       'body': '${_authController.getName(_authController.currentUser)} invited you to join a live',
//                                                                                                       'from': _authController.currentUser.uid,
//                                                                                                       'collection': FirebaseCollections.STREAMING_COLLECTIONS,
//                                                                                                       'collectionId': widget.streamingId,
//                                                                                                       'title': 'Invite Alert',
//                                                                                                       'date': FieldValue.serverTimestamp(),
//                                                                                                       'seen': false,
//                                                                                                     });

//                                                                                                     Navigator.pop(context);
//                                                                                                     showSnackBar(title: 'Done', body: 'Invite sent');
//                                                                                                   },
//                                                                                                   leading: CircleAvatar(radius: 35, backgroundImage: NetworkImage(getProfileUrl(user))),
//                                                                                                   title: Text(user.userName ?? user.uid),
//                                                                                                   subtitle: Text(user.name ?? ''),
//                                                                                                   trailing: Text(
//                                                                                                     'Invite',
//                                                                                                     style: TextStyle(color: AppColors.PRIMARY_COLOR, fontSize: 18),
//                                                                                                   )),
//                                                                                             );
//                                                                                           },
//                                                                                         );
//                                                                                       }
//                                                                                       return ProgressBar();
//                                                                                     },
//                                                                                   ))
//                                                                               .toList(),
//                                                                         ),
//                                                                       )
//                                                                     ],
//                                                                   ))));
//                                             }
//                                           },
//                                         )
//                                       : SizedBox(),
//                                 ),
//                               ),
//                             ),
//                             Spacer(),
//                           ],
//                         ),
//                       );
//                     }),
//               ),
//             ],
//           );
//         } else {
//           return ProgressBar();
//         }
//       },
//     );
//   }

//   String winerUid;
//   int pkInviteSentSeconds = 0;
//   var scoreMap = Map();
//   decideWiner() {}
//   Widget pKView() {
//     List<LiveVideoModel> members =
//         stream.members.map((e) => LiveVideoModel.fromMap(e)).toList();
//     if (!stream.pkDetails.pkStarted && widget.role == ClientRole.Audience) {
//       return remoteview.SurfaceView(uid: members[0].videoId);
//     }
//     final List<Color> colors = [
//       Colors.red,
//       Colors.green,
//     ];
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//             height: Get.height * 0.40,
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       ...members
//                           .map((vm) => Stack(
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       setState(() {
//                                         selectedUserId = vm.uid;
//                                       });
//                                     },
//                                     child: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         Container(
//                                           width: Get.width / 2,
//                                           child: _auth.currentUser != null &&
//                                                   vm.uid ==
//                                                       _auth.currentUser.uid
//                                               ? localview.SurfaceView()
//                                               : remoteview.SurfaceView(
//                                                   uid: vm.videoId),
//                                         ),
//                                         if (stream.pkDetails.pkEnded &&
//                                             winerUid == vm.uid)
//                                           Container(
//                                             height: 60,
//                                             width: 80,
//                                             decoration: BoxDecoration(),
//                                             child: Transform.rotate(
//                                               angle: 45,
//                                               child: Text(
//                                                 'WINNER',
//                                                 style: Get.textTheme.headline6
//                                                     .copyWith(
//                                                         color: AppColors
//                                                             .PRIMARY_COLOR),
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       vm.name,
//                                       style: Get.textTheme.bodyText1
//                                           .copyWith(color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               ))
//                           .toList(),
//                       if (members.length == 1)
//                         Container(
//                           width: Get.width / 2,
//                           color: Colors.yellow.withOpacity(0.5),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left:20.0),
//                                 child: Text(
//                                   'Waiting for invite to be  accepted',
//                                   style: Get.textTheme.bodyText2.copyWith(color: Colors.white),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               StreamBuilder(
//                                 stream: Stream.periodic(
//                                     Duration(seconds: 1), (e) => e),
//                                 builder: (_, snapshot) {
//                                   if (pkInviteSentSeconds > 59) {
//                                     WidgetsBinding.instance
//                                         .addPostFrameCallback(
//                                             (timeStamp) async {
//                                       await FirebaseFirebaseFirestore.instance
//                                           .collection(FirebaseCollections
//                                               .STREAMING_COLLECTIONS)
//                                           .doc(stream.docId)
//                                           .update({
//                                         'isPk': false,
//                                       });
//                                       pkInviteSentSeconds=0;
                                      
//                                     });
//                                   }
//                                   if (snapshot.hasData) {
//                                     pkInviteSentSeconds++;
//                                   }
//                                   return Text(
//                                     '$pkInviteSentSeconds seconds',
//                                     style: Get.textTheme.caption,
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         )
//                     ],
//                   ),
//                 ),
//                 if (stream.pkDetails != null && stream.pkDetails.pkStarted)
//                   StreamBuilder(
//                       stream: FirebaseFirebaseFirestore.instance
//                           .collection(FirebaseCollections.STREAMING_COLLECTIONS)
//                           .doc(widget.oldStream.docId)
//                           .collection('sent-gifts')
//                           .doc('count')
//                           .snapshots(),
//                       builder: (context,
//                           AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
//                               snapshot) {
//                         if (snapshot.hasData) {
//                           var data = snapshot.data.data();
//                           members.forEach((element) {
//                             var score = 0;
//                             if (data != null && data.containsKey(element.uid)) {
//                               score = data[element.uid];
//                             }
//                             scoreMap[element.uid] = score;
//                           });
//                           return Container(
//                             height: 30,
//                             width: Get.width,
//                             child: Row(
//                               children: members
//                                   .map((e) => Expanded(
//                                           child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.end,
//                                               children: [
//                                             Expanded(
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: colors[
//                                                       members.indexOf(e)],
//                                                 ),
//                                                 width: Get.width / 2,
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 8),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     members.indexOf(e) == 0
//                                                         ? MainAxisAlignment
//                                                             .start
//                                                         : MainAxisAlignment.end,
//                                                 children: [
//                                                   Icon(Icons.star,
//                                                       size: 15,
//                                                       color: colors[
//                                                           members.indexOf(e)]),
//                                                   Text(
//                                                     '${scoreMap[e.uid]}',
//                                                     style: TextStyle(
//                                                         color: Colors.white),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ])))
//                                   .toList(),
//                             ),
//                           );
//                         }
//                         return SizedBox();
//                       }),
//               ],
//             )),
//         if (stream.pkDetails.pkStarted)
//           Positioned(
//             bottom: 30,
//             child: Container(
//               height: 25,
//               width: 70,
//               decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(15),
//                       topRight: Radius.circular(15))),
//               child: Builder(
//                 builder: (context) {
//                   var nowDate = DateTime.now();
//                   var startedTime = stream.pkDetails.startedAt;
//                   int pkseconds = stream.pkDetails.pkTime * 60;
//                   var diif = nowDate.difference(startedTime).inSeconds;
//                   print('diif in seconds =$diif');
//                   var durationLeftInSeconds =
//                       pkseconds - nowDate.difference(startedTime).inSeconds;
//                   int pkTimeEllapsed = 0;
//                   return StreamBuilder(
//                     stream: Stream.periodic(Duration(seconds: 1), (s) => s),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         int durationLeftStream =
//                             durationLeftInSeconds - pkTimeEllapsed;
//                         pkTimeEllapsed++;
//                         if (durationLeftStream > 0) {
//                           var inMinutes = (durationLeftStream / 60.0)
//                               .toString()
//                               .split('.')[0]
//                               .padLeft(2, '0');
//                           var inSeconds = durationLeftStream % 60;
//                           print('$inMinutes:$inSeconds');
//                           return Center(
//                             child: Text(
//                               '$inMinutes:${inSeconds.toString().padLeft(2, '0')}',
//                               style: Get.textTheme.caption
//                                   .copyWith(color: Colors.white),
//                             ),
//                           );
//                         } else {
//                           if (stream.pkDetails != null &&
//                               !stream.pkDetails.pkEnded &&
//                               widget.role == ClientRole.Broadcaster &&
//                               stream.streamer.uid ==
//                                   _authController.currentUser.uid)
//                             WidgetsBinding.instance
//                                 .addPostFrameCallback((timeStamp) {
//                               bool isDraw = false;
//                               setState(() {
//                                 var score1 =
//                                     scoreMap[scoreMap.keys.elementAt(0)];
//                                 var score2 =
//                                     scoreMap[scoreMap.keys.elementAt(1)];
//                                 if (score1 > score2) {
//                                   winerUid = scoreMap.keys.elementAt(0);
//                                 } else if (score1 == score2) {
//                                   isDraw = true;
//                                 } else {
//                                   winerUid = scoreMap.keys.elementAt(1);
//                                 }
//                               });
//                               var pkd = stream.pkDetails;
//                               pkd.pkEnded = true;
//                               pkd.winerId = winerUid;
//                               pkd.isDraw = isDraw;
//                               FirebaseFirebaseFirestore.instance
//                                   .collection(
//                                       FirebaseCollections.STREAMING_COLLECTIONS)
//                                   .doc(widget.oldStream.docId)
//                                   .update({'pkDetails': pkd.toMap()});
//                             });
//                           return Center(
//                             child: Text(
//                               'Ended',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           );
//                         }
//                       }
//                       return Text('...');
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         if (!stream.pkDetails.pkEnded &&
//             (stream.pkDetails.pkStarted ||
//                 widget.role == ClientRole.Broadcaster))
//           Container(
//             child: Transform.rotate(
//               angle: 45,
//               child: Text(
//                 'VS',
//                 style: TextStyle(fontSize: 30, color: AppColors.PRIMARY_COLOR),
//               ),
//             ),
//           ),
//         if (stream.pkDetails.pkEnded && stream.pkDetails.isDraw)
//           Container(
//             child: Transform.rotate(
//               angle: 45,
//               child: Text(
//                 'Draw',
//                 style: TextStyle(fontSize: 30, color: AppColors.PRIMARY_COLOR),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return stream == null
//         ? SizedBox()
//         : Stack(
//             children: [
//               WillPopScope(
//                 onWillPop: () async {
//                   if (widget.role == ClientRole.Audience) {
//                     await disposeAll(false);
//                   } else {
//                     await disposeAll(true);
//                   }
//                   return true;
//                 },
//                 child: GestureDetector(
//                   onHorizontalDragEnd: (detail) {
//                     if (detail.primaryVelocity > 1500) {
//                       streamController.showVideoStack.value = true;
//                     } else if (detail.primaryVelocity < -1500) {
//                       streamController.showVideoStack.value = false;
//                     }
//                   },
//                   child: Scaffold(
//                     body: Container(
//                       height: Get.height,
//                       width: Get.width,
//                       decoration: BoxDecoration(gradient: gradient),
//                       child: Stack(
//                         children: [
//                           Stack(
//                             children: <Widget>[
//                               stream.isPk != null && stream.isPk
//                                   ? Positioned(top: 100, child: pKView())
//                                   : widget.callType == "Video" &&
//                                           !stream.allowMutiple
//                                       ? _viewRows()
//                                       : (widget.callType == "Video" ||
//                                                   widget.callType == 'Audio') &&
//                                               stream.allowMutiple
//                                           ? multipleGuestView(
//                                               widget.callType == 'Video'
//                                                   ? true
//                                                   : false)
//                                           : Container(
//                                               alignment: Alignment.center,
//                                               child: Icon(
//                                                 Icons.person,
//                                                 size: 60,
//                                                 color: Theme.of(context)
//                                                     .primaryColor,
//                                               ),
//                                             ),
//                               // _panel(),
//                             ],
//                           ),
//                           if (stream != null)
//                             StreamingTopView(selectedUserId, stream, () {
//                               _onStreamEnd(context);
//                             }, widget.role, engine, widget.callType, myId)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               if (widget.channelName == defaultUid)
//                 Positioned(
//                   top: 20,
//                   left: 0,
//                   child: Transform.rotate(
//                     angle: 0,
//                     child: Container(
//                       height: 20,
//                       width: 70,
//                       child: Center(
//                         child: Text(
//                           'Development',
//                           textDirection: TextDirection.ltr,
//                           style: TextStyle(fontSize: 10, color: Colors.white),
//                         ),
//                       ),
//                       color: Colors.deepOrange[900],
//                     ),
//                   ),
//                 ),
//             ],
//           );
//   }
// }
