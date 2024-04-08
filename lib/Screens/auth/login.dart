import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../Screens/Tab.dart';
import '../../Screens/welcome/Welcome.dart';
import '../../Screens/auth/otp.dart';
import '../../models/custom_web_view.dart';
import '../../util/color.dart';




  Widget errmsg(String text,bool show){
  //error message widget.
      if(show == true){
        //if error is true then show error message box
        return Container(
            padding: EdgeInsets.all(10.00),
            margin: EdgeInsets.only(bottom: 10.00),
            // color: Colors.red,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Container(
                    margin: EdgeInsets.only(right:6.00),
                    child: Icon(Icons.info, color: Colors.white),
                ), // icon for error message
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: TextStyle(color: Colors.white)),
                    Text("You need internet connection to use this app..", style: TextStyle(color: Colors.white.withOpacity(0.6)), )
                  ],
                ),
                //show error message text
            ]),
        );
      }else{
         return Container();
         //if error is false, return empty container.
      }
  }

class Loginn extends StatefulWidget {
  @override
  _LoginnState createState() => _LoginnState();
}

class _LoginnState extends State<Loginn> {

  StreamSubscription internetconnection;
  bool isoffline = false;

  @override
  void initState() {
    internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        // whenevery connection status is changed.
        if(result == ConnectivityResult.none){
             //there is no any connection
             setState(() {
                 isoffline = true;
             }); 
        }else if(result == ConnectivityResult.mobile){
             //connection is mobile data network
             setState(() {
                isoffline = false;
             });
        }else if(result == ConnectivityResult.wifi){
            //connection is from wifi
            setState(() {
               isoffline = false;
            });
        }
    }); // using this listiner, you can get the medium of connection as well.

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    internetconnection.cancel();
    //cancel internent connection subscription after you are done
  }


  void _showdialog(context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No Internet'),
        content: Text("The app doesn't work offline.."),
        actions: <Widget>[
          FlatButton(
            // method to exit application programitacally
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Login(isOfflinef: isoffline == null ? false : isoffline);
  }
}

class Login extends StatelessWidget {
  static const your_client_id = '000000000000';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const your_redirect_url =
      'https://dating-7dd58.firebaseapp.com/__/auth/handler';

    final bool isOfflinef;

    Login({this.isOfflinef});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Theme.of(context).primaryColor.withOpacity(.5),
              Theme.of(context).primaryColor.withOpacity(.8),
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,

              //Color(0xffBD34C59),
              //Color(0xffBD34C59),
              //Color(0xffBD34C59),
            ]),
          ),
          child: Column(
            children: <Widget>[

              errmsg("No internet", isOfflinef),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.47,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "Welcome to Coonec",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.only(top: 25),
                          padding: EdgeInsets.only(
                            left: 49,
                            right: 49,
                          ),
                          child: Image.asset("asset/logo.png"),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32
                          ),
                          child: Text(
                            "A digital community stunning engaging online experiences",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    )
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(14),
                      child: Text(
                      "Continue with one of the following option to get started or LOG IN", 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                    ),
      
                    SizedBox(height: 25),
      
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8, bottom: 8),
                  //   child: Material(
                  //     elevation: 2.0,
                  //     borderRadius: BorderRadius.all(Radius.circular(30)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(6.0),
                  //       child: InkWell(
                  //         child: Container(
                  //             decoration: BoxDecoration(
                  //                 shape: BoxShape.rectangle,
                  //                 borderRadius: BorderRadius.circular(25),
                  //                 gradient: LinearGradient(
                  //                     begin: Alignment.topRight,
                  //                     end: Alignment.bottomLeft,
                  //                     colors: [
                  //                       Theme.of(context).primaryColor.withOpacity(.5),
                  //                       Theme.of(context).primaryColor.withOpacity(.8),
                  //                       Theme.of(context).primaryColor,
                  //                       Theme.of(context).primaryColor
                  //                     ])),
                  //             height: MediaQuery.of(context).size.height * .065,
                  //             width: MediaQuery.of(context).size.width * .8,
                  //             child: Center(
                  //                 child:  Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Image.asset("asset/facebook.png", height: 23),
                  //                     SizedBox(width: 12),
                  //                     Text(
                  //               "CONTINUE WITH FACEBOOK",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white,
                  //                   ),
                                    
                  //             ),
                  //                   ],
                  //                 ),
                  //             )
                  //             ),
                  //         onTap: () async {
                  //                                     showDialog(
                  //               builder: (context) => Container(
                  //                   height: 30,
                  //                   width: 30,
                  //                   child: Center(
                  //                       child: CupertinoActivityIndicator(
                  //                     key: UniqueKey(),
                  //                     radius: 20,
                  //                     animating: true,
                  //                   ))), context: context);
                  //           await handleFacebookLogin(context).then((user) {
                  //             navigationCheck(user, context);
                  //           }).then((_) {
                  //             Navigator.pop(context);
                  //           }).catchError((e) {
                  //             Navigator.pop(context);
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
      
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.018, ),
      
                  OutlineButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .75,
                      child: Center(
                          child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone,),
                                      SizedBox(width: 12),
                                      Text(
                                "CONTINUE WITH PHONE NUMBER",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.5),
                                    ),
                                    
                              ),
                                    ],
                                  ),
                                  ),
                    ),
                    borderSide: BorderSide(
                        width: 1, style: BorderStyle.solid, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: () {
                      bool updateNumber = false;
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => OTP(updateNumber)));
                    },
                  ),
      
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018, ),
      
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InkWell(
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Theme.of(context).primaryColor.withOpacity(.5),
                                        Theme.of(context).primaryColor.withOpacity(.8),
                                        Theme.of(context).primaryColor,
                                        Theme.of(context).primaryColor
                                      ])),
                              height: MediaQuery.of(context).size.height * .065,
                              width: MediaQuery.of(context).size.width * .8,
                              child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("asset/google.png", height: 23),
                                      SizedBox(width: 12),
                                      Text(
                                "CONTINUE WITH GOOGLE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    ),
                                    
                              ),
                                    ],
                                  ),
                              )),
                          onTap: () async {
                              showDialog(
                                builder: (context) => Container(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                        child: CupertinoActivityIndicator(
                                      key: UniqueKey(),
                                      radius: 20,
                                      animating: true,
                                    ))), context: context);
                            await handleGoogleLogin(context).then((user) {
                              navigationCheck(user, context);
                            }).then((_) {
                              Navigator.pop(context);
                            }).catchError((e) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
      
      
                  ],
                ),
            ],
                ),
              ))
            ],
          ),
        ),
    ),
    );
  }

  // Future<User> handleFacebookLogin(context) async {
  //   User user;
  //   String result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => CustomWebView(
  //               selectedUrl:
  //                   'https://www.facebook.com/dialog/oauth?client_id=$your_client_id&redirect_uri=$your_redirect_url&response_type=token&scope=email,public_profile,',
  //             ),
  //         maintainState: true),
  //   );
  //   if (result != null) {
  //     try {
  //       final facebookAuthCred =
  //           FacebookAuthProvider.getCredential(accessToken: result);
  //       user =
  //           (await FirebaseAuth.instance.signInWithCredential(facebookAuthCred))
  //               .user;

  //       print('user $user');
  //     } catch (e) {
  //       print('Error $e');
  //     }
  //   }
  //   return user;
  // }

  Future<User> handleGoogleLogin(context) async {

    User user;

    try {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

  final googleAuthCred = await _auth.signInWithCredential(credential);

  user = googleAuthCred.user;


  } catch(error) {
    print("Error $error");
  }
    return user;
  }




  Future navigationCheck(User currentUser, context) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('userId', isEqualTo: currentUser.uid)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      if (snapshot.docs.length > 0) {
        if (snapshot.docs[0].data()['location'] != null) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => Tabbar(null, null)));
        } else {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Welcome()));
        }
      } else {
        await _setDataUser(currentUser);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Welcome()));
      }
    });
  }

}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Future _setDataUser(User user) async {
  await FirebaseFirestore.instance.collection("Users").doc(user.uid).set(
    {
      'userId': user.uid,
      'UserName': user.displayName ?? '',
      'Pictures': FieldValue.arrayUnion([
        user.photoURL ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxUC64VZctJ0un9UBnbUKtj-blhw02PeDEQIMOqovc215LWYKu&s'
      ]),
      'phoneNumber': user.phoneNumber,
      'timestamp': FieldValue.serverTimestamp()
    },
  );
}
