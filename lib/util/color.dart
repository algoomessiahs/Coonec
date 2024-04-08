import 'package:flutter/material.dart';

Color primaryColor = Color(0xff5a3aff);
Color secondryColor = Colors.grey;
Color darkPrimaryColor = Color(0x22ff3a5a);
Color textColor = Colors.white;



Widget backButtonCust(context) {
  return IconButton(
              color: secondryColor,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            );
}