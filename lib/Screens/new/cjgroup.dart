import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'publicGroups.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import 'createGroup.dart';
import 'joinGroup.dart';
import 'package:flutter/material.dart';

class Cjgroup extends StatefulWidget {
  final List<GroupModel> groups;

  Cjgroup(this.groups);

  @override
  _CjgroupState createState() => _CjgroupState();
}

class _CjgroupState extends State<Cjgroup> {

AUser currentUser;

@override
  void initState() {
    _getCurrentUser();
    super.initState();
  }


  _getCurrentUser() async {
    try {
      User user = await FirebaseAuth.instance.currentUser;
      return FirebaseFirestore.instance.collection('Users').doc("${user.uid}").snapshots().listen((data) async {
        currentUser = AUser.fromDocument(data.data());
        if (mounted) setState(() {});
        return currentUser;
      });
    }catch(e){
      print("_getCurrentUser ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    void _goToJoin(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinGroup(
            currentUser: currentUser,
          ),
        ),
      );
    }

    void _goToCreate(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroup(
            currentuser: currentUser
            ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, ),

                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
          ),
            ],
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 80),
            child: Image.asset("asset/logo.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Join or Create a group..",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "By creating or joing a group you can chat with multiple people and discuss about a certain topic",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey[600],
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [

                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: RaisedButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .65,
                      child: Center(
                        child: Text(
                          "View Public Groups",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PublicGroups(),
                      )
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                      OutlineButton(
                        child: Container(
                          height: MediaQuery.of(context).size.height * .065,
                          width: MediaQuery.of(context).size.width * .30,
                          child: Center(
                              child: Text(
                                    "Create",
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
                        onPressed: () {
                          _goToCreate(context);
                        },
                      ),
                      RaisedButton(

                        child: Container(
                          height: MediaQuery.of(context).size.height * .065,
                          width: MediaQuery.of(context).size.width * .30,
                          child: Center(
                              child: Text(
                                    "Join",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.5),
                                        ),
                                        
                                  ),
                                      ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        onPressed: () {
                          _goToJoin(context);
                        },
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


