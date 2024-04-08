import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/group_model.dart';


class PublicGroups extends StatefulWidget {
  
  // final List<GroupModel> groups;

  // PublicGroups(this.groups);

  

  @override
  _PublicGroupsState createState() => _PublicGroupsState();
}

class _PublicGroupsState extends State<PublicGroups> {

  List<GroupModel> groups;


  Future<bool> _getCurrentGroups() async {
    try {
       FirebaseFirestore.instance
          .collection('Groups')
          .orderBy('groupCreated', descending: true)
          .snapshots()
          .listen((ondata) {
        //groups.clear();
        if (ondata.docs.length > 0) {
          groups = [];
          ondata.docs.forEach((f) async {
            // DocumentSnapshot doc = await FirebaseFirestore.instance.doc(f.data()['Groups']).get();
            // print(doc);
            if (f.exists) {
              GroupModel tempGroupp = GroupModel.fromDocument(f);
                if (tempGroupp.isPrivate==false) {
                  groups.add(tempGroupp);
                }
            }
          });
        }
      });

       //if (mounted) setState(() {});
       return true;

    } catch (e) {
      print("_getCurrentGroup ${e.toString()}");
      return false;
    }
  }

  @override
  void initState() {

    super.initState();

    _getCurrentGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups For You"),
      ),
      body: FutureBuilder(
        future: _getCurrentGroups(),

        builder: (context, snapshot) {

          if (groups.length == 0) {
            return Center(
              child: Text(
                "Can't find any Group for you..",
                style: TextStyle(
                  fontSize: 20,
                ),
                ),
            );
          }

          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done)
            return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (ctx, i) {
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(border: new Border(right: new BorderSide(width: 1.0, color: Colors.black.withOpacity(0.7)))),
                    child: Icon(Icons.group), // Hardcoded to be 'x'
                  ),
                  title: Text(
                    //"Programming and Money",
                    groups[i].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0), child: Text(
                        //"24 Members"
                        groups[i].members.length == 1 ? groups[i].members.length.toString() + " " + "Member" : groups[i].members.length.toString() + " " + "Members",
                        )),
                    ],
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.copy, size: 30.0),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                          text: groups[i].id,
                        ));
                      }),
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                      text: groups[i].id,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Group Id Copied!'),)
                    );
                  },
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ],
            );
          });

          else {
            return Container(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    );
          }

        }
        ),
    );
  }
}

