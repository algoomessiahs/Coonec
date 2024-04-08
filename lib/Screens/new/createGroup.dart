import 'package:flutter/material.dart';

import 'cjFuture.dart';
import '../../models/user_model.dart';

class CreateGroup extends StatefulWidget {
  final AUser currentuser;

  CreateGroup({@required this.currentuser});

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

  TextEditingController _groupNameController = TextEditingController();

  bool isPrivate = false;

  void _createGroup(BuildContext context, String groupName, bool isPrivatee) async {
    String _returnString = await CjFuture().createGroup(groupName, widget.currentuser.id, widget.currentuser, isPrivatee);

    //print(_returnString + " " + widget.currentUser.id);
    if(_returnString == "success") {
      // Navigator.push(
      //   context, 
      //   MaterialPageRoute(builder: (context) => GroupChatPage(groupName: groupName, groupchatId: widget.currentuser.groupIds.where((element) => element == _groupNameController.text).toString(), sender: widget.currentuser))
      //   );
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("There was some error while creating the group. Please try again later!")));
      //Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: "Group Name",
                    ),
                  ),

                  SizedBox(height: 20,),
                  
                  Row(
                    children: [
                      Checkbox(
                        value: isPrivate,
                      activeColor: Colors.green,
                      onChanged:(bool newValue){
                        setState(() {
                          isPrivate = newValue;
                          });
          }),

          Text('Make this Group Private..'),

                    ],
                  ),

                  SizedBox(height: 20.0),

                  RaisedButton(

                    child: Container(
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .40,
                      child: Center(
                          child: Text(
                                "CREATE GROUP",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.5),
                                    ),
                                    
                              ),
                                  ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: () async {
                      _createGroup(context, _groupNameController.text, isPrivate);
                      //print("FUCK " + widget.currentuser.id);
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
