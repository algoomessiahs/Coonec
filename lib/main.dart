import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
//adsf import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Screens/Splash.dart';
import '../Screens/Tab.dart';
import '../Screens/welcome/Welcome.dart';
import '../Screens/auth/login.dart';
import '../ads/ads.dart';
import '../util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isAuth = false;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
    //adsf FirebaseAdMob.instance.initialize(appId: Platform.isAndroid ? androidAdAppId : iosAdAppId);
  }

  Future _checkAuth() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;
      print(user);
      if (user != null) {
        await FirebaseFirestore.instance.collection('Users').where('userId', isEqualTo: user.uid).get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
              print("SnapFuck");
              print(snapshot.docs[0].data()['location']);
          if (snapshot.docs.length > 0) {
            // print(snapshot.docs[0].data());
            if (snapshot.docs[0].data()['location'] != null) {
              setState(() {
                isRegistered = true;
                isLoading = false;
              });
            } else {
              setState(() {
                isAuth = true;
                isLoading = false;
              });
            }
            print("loggedin ${user.uid}");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
  }

  // Future _checkAuth() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   User user = _auth.currentUser;
  //     print(user);
  //     if (user != null) {
  //       isRegistered = true;
  //     } else {
  //       setState(() {
  //         isRegistered = false;
  //       });
  //     }
  // }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: "Nunito",
      ),
      home: isLoading
          ? Splash()
          : isRegistered
              ? Tabbar(null, null)
              : isAuth
                  ? Welcome()
                  : Login(),
    );
  }
}
