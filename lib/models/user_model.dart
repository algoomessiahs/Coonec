import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AUser {
  final String id;
  final String name;
  final bool isBlocked;
  String address;
  final Map coordinates;
  final List sexualOrientation;
  final String gender;
  final String showGender;
  final int age;
  final String phoneNumber;
  int maxDistance;
  Timestamp lastmsg;
  final Map ageRange;
  final Map editInfo;
  List imageUrl = [];

  List groupIds;

  var distanceBW;
  AUser({
    @required this.id,
    @required this.age,
    @required this.address,
    this.isBlocked,
    this.coordinates,
    @required this.name,
    @required this.imageUrl,
    this.phoneNumber,
    this.lastmsg,
    this.gender,
    this.showGender,
    this.ageRange,
    this.maxDistance,
    this.editInfo,
    this.distanceBW,
    this.sexualOrientation,

    this.groupIds,
  });
  factory AUser.fromDocument(Map<String, dynamic> doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return AUser(
        id: doc['userId'],

        //groupIds: doc['groupId'],
        groupIds: doc['groupIds'] != null ? 
        List.generate(doc['groupIds'].length, (index) { return doc['groupIds'][index]; } ) 
        : [],

        isBlocked: doc['isBlocked'] != null ? doc['isBlocked'] : false,
        phoneNumber: doc['phoneNumber'],
        name: doc['UserName'],
        editInfo: doc['editInfo'],
        ageRange: doc['age_range'],
        showGender: doc['showGender'],
        maxDistance: doc['maximum_distance'],
        sexualOrientation: doc['sexualOrientation']['orientation'] ?? "",
        age: ((DateTime.now()
                    .difference(DateTime.parse(doc["user_DOB"]))
                    .inDays) /
                365.2425)
            .truncate(),
        address: doc['location']['address'],
        coordinates: doc['location'],
        // university: doc['editInfo']['university'],
        imageUrl: doc['Pictures'] != null
            ? List.generate(doc['Pictures'].length, (index) {
                return doc['Pictures'][index];
              })
            : []
            );
  }
}
