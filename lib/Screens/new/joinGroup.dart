import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/models/group_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../models/group_model.dart';
import '../../Screens/Chat/groupchatPage.dart';
import 'cjFuture.dart';


class JoinGroup extends StatefulWidget {
  final AUser currentUser;

  JoinGroup({@required this.currentUser});
  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {

  // void _joinGroup(BuildContext context, String groupId) async {
  //   FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser;
  //    await CjFuture().joinGroup(groupId, _currentUser.uid);
  // }

  void _joinGroup(BuildContext context, String groupId) async {
    String _returnString = await CjFuture().joinGroup(groupId, widget.currentUser.id);
    if(_returnString == "success") {
      // Navigator.push(
      //   context, 
      //   MaterialPageRoute(builder: (context) => GroupChatPage(groupchatId: groupId, sender: widget.currentUser))
      //   );
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You have entered the wrong Id")));
      //Navigator.pop(context);
    }
  }

  TextEditingController _groupIdController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference groupReference;
  List<String> members;

  @override
  void initState() {
    groupReference = FirebaseFirestore.instance.collection("Users").doc().collection('Groups');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: Offset(
              4.0,
              4.0,
            ),
          )
        ],
      ),
      child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _groupIdController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Group Id",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  OutlineButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .40,
                      child: Center(
                          child: Text(
                                "JOIN",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.5),
                                    ),
                                    
                              ),
                                  ),
                    ),
                    borderSide: BorderSide(
                        width: 1, style: BorderStyle.solid, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: () async {
                     _joinGroup(context, _groupIdController.text);

//                            members.add(widget.currentUser.id);
//       await FirebaseFirestore.instance
//           .collection('Groups').doc(_groupIdController.text).updateData({
//         'members': FieldValue.arrayUnion(members),
//       });


// await FirebaseFirestore.instance.collection("Users").doc(widget.currentUser.id).collection("Groups").doc(_groupIdController.text).set(
//   {
//     'groupId': _groupIdController.text,
// }
// );


                    },
                  ),
                ],
              ),
    ),

          ),
          Spacer(),
        ],
      ),
    );
  }
}