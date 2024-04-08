import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String id;
  String name;
  String leader;
  String image;
  List<String> members;
  Timestamp groupCreated;

  bool isPrivate;

  GroupModel({
    this.id,
    this.name,
    this.leader,
    this.image,
    this.members,
    this.groupCreated,

    this.isPrivate,
  });

  // GroupModel.fromDocument(DocumentSnapshot doc) {
  //   id = doc.id;
  //   name = doc["name"];
  //   leader = doc["leader"];
  //   members = List<String>.from(doc["members"]);
  //   groupCreated = doc["groupCreated"];
  // }

  factory GroupModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return GroupModel(
        //id: doc['userId'],
    id: doc.id,
    name: doc["name"],
    leader: doc["leader"],
    image: doc["image"],
    members: List<String>.from(doc["members"]),
    groupCreated: doc["groupCreated"],

    isPrivate: doc['isPrivate'],
    );
  }

}
