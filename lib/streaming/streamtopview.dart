
// import 'package:agora_rtc_engine/rtc_engine.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';


// import 'package:visionlive/constants/constants.dart';
// import 'package:visionlive/controllers/controllers.dart';
// import 'package:visionlive/model/models.dart';
// import 'package:visionlive/widgets/widgets.dart';

// class StreamingTopView extends StatefulWidget {
//   final UserStream stream;
//   final Function onEnd;
//   final ClientRole role;
//   final RtcEngine engine;
//   final String callType;
//   final int agoraId;
//   final String selectedUserId;
//   StreamingTopView(this.selectedUserId,this.stream, this.onEnd,this.role,this.engine,this.callType,this.agoraId);

//   @override
//   _StreamingTopViewState createState() => _StreamingTopViewState();
// }

// class _StreamingTopViewState extends State<StreamingTopView> {
//   final _firestore = FirebaseFirebaseFirestore.instance;
//   bool showStack = true;
//   final streamController = Get.find<UserStreamController>();
//   final _auth=FirebaseAuth.instance;
//   Widget _buildOtherUsers(List<Map<String, dynamic>> otherUsers) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       reverse: true,
//       itemCount: otherUsers.length,
//       itemBuilder: (context, int index) {
//         String pp = otherUsers[index]['profilePicture'];
//         String uid=otherUsers[index]['uid'];
//         return UserDetailBottomSheet(
//             uid,
//                   child: CircleAvatar(
//             radius: 15,
//               backgroundImage: pp != null && pp.length > 10
//                   ? NetworkImage(pp)
//                   : AssetImage('assets/images/gigo.png')),
//         );
//       },
//     );
//   }

//   Widget _buildStreamerProfile(UserStream stream, int listeners) {
//     ApplicationUser user=stream.streamer;
//     return Container(
//       height: 35,
//       width: 140,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           border:
//               Border.fromBorderSide(BorderSide(color: Colors.yellowAccent))),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(width: 5),
//           UserDetailBottomSheet(
//             user.uid,
//                       child: CircleAvatar(
//                 radius: 15, backgroundImage:user.profilePicture!=null && user.profilePicture.isNotEmpty?
//                  NetworkImage(user.profilePicture):AssetImage('assets/images/gigo.png')
//                  ),
//           ),
//           SizedBox(width: 5),
//           Expanded(
//             child: Column(
//               children: [
//                 Builder(
//                   builder: (_) {
//                     var name = '';
//                     if (user.name != null && user.name.length > 0) {
//                       if (user.name.length > 6) {
//                         name = user.name.substring(0, 5);
//                       } else {
//                         name = user.name;
//                       }
//                     } else if (user.userName != null &&
//                         user.userName.length > 0) {
//                       if (user.userName.length > 6) {
//                         name = user.userName.substring(0, 5);
//                       } else {
//                         name = user.userName;
//                       }
//                     }
//                     return Text(
//                       name,
//                       style: TextStyle(color: Colors.white, fontSize: 14),
//                     );
//                   },
//                 ),
               
//                 Row(
//                   children: [
//                      SizedBox(width:5),
//                     Icon(
//                       Icons.group,
//                       size: 12,
//                       color: Colors.white,
//                     ),
//                     SizedBox(width:2),
//                     Text(
//                       listeners.toString(),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontStyle: FontStyle.italic),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//        _auth.currentUser!=null && _auth.currentUser.uid==stream.streamer.uid?Expanded(child: Container()):  Expanded(
//               child: GestureDetector(
//             child: Container(
//               height: 30,
//               width: 30,
//               decoration: BoxDecoration(
//                   color: AppColors.PRIMARY_COLOR, shape: BoxShape.circle),
//               child: Center(
//                   child: Icon(
//                 Icons.add,
//                 color: Colors.white,
//               )),
//             ),
//           )),
//         ],
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         height: Get.height,
//         child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               height: 100,
//               child:   
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 40,
//                             width: double.infinity,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 _buildStreamerProfile(widget.stream,
//                                     widget.stream.listeners.length),
//                                 Expanded(
//                                     child:
//                                         _buildOtherUsers(widget.stream.listeners)),
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.clear,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () {
//                                     widget.onEnd();
//                                     //  Get.find<UserStreamController>().showVideoStack.value=false;
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
                  
                
//               ),
            
//             Spacer(),
            
//             Obx(
//               () => streamController.showVideoStack.value
//                   ? Container(
//                       height: 300,
//                       margin: const EdgeInsets.only(bottom: 10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                               widget.stream!=null && widget.stream.chatTitle!=null && widget.stream.chatTitle.isNotEmpty?widget.stream.chatTitle:''
// ,
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                           Expanded(
//                               child: Container(
                               
//                                 child: StreamBuilder(
//                             stream: _firestore
//                                   .collection(
//                                       FirebaseCollections.STREAMING_COLLECTIONS)
//                                   .doc(widget.stream.docId)
//                                   .collection('comments')
//                                   .orderBy('date', descending: true)
//                                   .snapshots(),
//                             builder: (_,
//                                   AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                                       snapshot) {
//                                 if (snapshot.hasData) {
//                                   return ListView.builder(
//                                     itemCount: snapshot.data.docs.length,
//                                     physics: BouncingScrollPhysics(),
//                                     reverse: true,
//                                     itemBuilder: (_, index) {
//                                       var doc = snapshot.data.docs[index].data();
//                                       String uid=  doc['by']['uid'];
//                                       return UserDetailBottomSheet(uid,
//                                                                               child: Container(
//                                          // height: 50,
//                                          padding: const EdgeInsets.all(8),
//                                           child: Row(
//                                             children: [
//                                               Icon(
//                                                 Icons.star,
//                                                 size: 20,
//                                                 color: AppColors.PRIMARY_COLOR,
//                                               ),
//                                               Expanded(
//                                                 child: Text(
//                                                   doc['by']['name'] +
//                                                       ': ' +
//                                                       doc['body'],
//                                                   softWrap: true,
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 } else {
//                                   return SizedBox();
//                                 }
//                             },
//                           ),
//                               )),
                        
//                          if(widget.stream!=null)  StreamingBottomView(
//                            widget.selectedUserId,
//                             widget.role,widget.engine,
//                         widget.callType=='Video'?true:false,widget.stream,widget.agoraId)
//                         ],
//                       ),
//                     )
//                   : SizedBox(),
//             ),
           
//           ],
//         ),
//       ),
//     );
//   }
// }
