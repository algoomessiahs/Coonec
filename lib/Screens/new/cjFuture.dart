import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/models/user_model.dart';

import '../../models/group_model.dart';

class CjFuture {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String> createGroup(String groupName, String userUid, AUser currentUser, bool isPrivate) async {
    String retVal = "error";
    List<String> members = List();
    List<String> gId = [];

    try {
      members.add(userUid);
      DocumentReference _docRef;
        _docRef = await _firestore.collection("Groups").add({
          'name': groupName,
          'leader': userUid,
          'image': currentUser.imageUrl[0],
          'members': members,
          'groupCreated': Timestamp.now(),

          'isPrivate': isPrivate,
        });

      gId.add(_docRef.id);

      await _firestore.collection("Users").doc(userUid).update({
        //'groupIds': _docRef.id,
        'groupIds': FieldValue.arrayUnion(gId),
      });

    FirebaseFirestore.instance.collection("groupchats").doc(_docRef.id).collection('messages').add({
      'type': 'Msg',
      'text': " Group  Created ",
      'sender_id': userUid,
      'sender_imageUrl': '',
      'receiver_group_id': _docRef.id,
      'isRead': false,
      'image_url': '',
      'time': FieldValue.serverTimestamp(),
    });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = "error";
    List<String> members = [];
    List<String> gId = [];
    try {
      gId.add(groupId);
      members.add(userUid);
      await _firestore.collection("Groups").doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
      });

      await _firestore.collection("Users").doc(userUid).update({
        'groupIds': FieldValue.arrayUnion(gId),
      });

      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }
  
}
