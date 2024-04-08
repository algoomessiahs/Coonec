// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final Firestore _firestore = FirebaseFirestore.instance;
// FirebaseUser firebaseUser;


// class ChatScreen extends StatefulWidget {
//   static const String id = "chat_screen";

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   String messageText;
//   final messageTextController = TextEditingController();
//   bool isMe;


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: null,

//         title: Text('Group Chat'),
//         backgroundColor: Colors.red,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             MessageStreamWidget(),
//             Container(
//               decoration: kMessageContainerDecoration,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       controller: messageTextController,
//                       onChanged: (value) {
//                         messageText = value;
//                         //Do something with the user input.
//                       },
//                       decoration: kMessageTextFieldDecoration,
//                     ),
//                   ),
//                   FlatButton(
//                     onPressed: () {
//                       messageTextController.clear();
//                       _firestore.collection('messages').doc().set(
//                           {'sender': firebaseUser.email, 'text': messageText, 'timestamp':
//                           DateTime.now().toUtc().millisecondsSinceEpoch});
//                       //Implement send functionality.
//                     },
//                     child: Text(
//                       'Send',
//                       style: kSendButtonTextStyle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MessageStreamWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
//       //Async Snapshot
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//         final messages = snapshot.datadocs;
//         List<TextBubble> messageWidgets = [];
//         for (var message in messages) {
//           final messageText = message.data()['text'];
//           final messageSender = message.data()['sender'];
          
//           final currentUser = firebaseUser.email;

//           final messageWidget =
//               TextBubble(sender: messageSender, text: messageText, 
//               isMe: currentUser == messageSender);
//           messageWidgets.add(messageWidget);
//         }
//         return Expanded(
//           child: ListView(
//             reverse: true,
//             children: messageWidgets,
//           ),
//         );
//       },
//     );
//   }
// }

// class TextBubble extends StatelessWidget {
//   final String sender;
//   final String text;
//   final bool isMe;

//   TextBubble({this.sender, this.text, this.isMe});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             sender, style: TextStyle(
//             color: Colors.grey,
//             fontSize: 11
//           ),
//           ),
//           Material(
//             borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(30),
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30)): BorderRadius.only(topRight: Radius.circular(30),
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30)),
//             elevation: 5,
//             color: isMe? Colors.redAccent: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Text(text,
//                 style: TextStyle(
//                   color: isMe?Colors.white:Colors.black,
//                   fontSize: 16
//                 ),),
//               )),
//         ],
//       ),
//     );
//   }
// }
