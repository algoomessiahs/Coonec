import 'package:flutter/material.dart';
import 'package:dating/util/color.dart';

class BlockUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondryColor.withOpacity(.5),
      body: Stack(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
AlertDialog(
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Colors.white,
        actions: [
          Text("For more contact it@coonec.com"),
        ],
        title: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                      height: 50,
                      width: 100,
                      child: Image.asset(
                        "asset/logo.png",
                        fit: BoxFit.contain,
                      )),
                )),
            Text(
              "sorry, you can't access the application!",
              style: TextStyle(color: primaryColor),
            ),
          ],
        ),
        content: Text(
            "you're blocked by the admin and your profile will also not appear for other users."),
      ),
        ],
      ),
    );
  }
}
