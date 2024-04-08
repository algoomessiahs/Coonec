import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Screens/Tab.dart';
import '../../Screens/auth/otp.dart';
import '../../util/color.dart';
import '../../util/snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'login.dart';

class Verification extends StatefulWidget {
  final bool updateNumber;
  final String phoneNumber;
  final String smsVerificationCode;
  Verification(this.phoneNumber, this.smsVerificationCode, this.updateNumber);

  @override
  _VerificationState createState() => _VerificationState();
}

var onTapRecognizer;

class _VerificationState extends State<Verification> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Login _login = new Login();
  Future updateNumber() async {
    User user = await FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .set({'phoneNumber': user.phoneNumber}).then((_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            Future.delayed(Duration(seconds: 2), () async {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Tabbar(null, null)));
            });
            return Center(
                child: Container(
                    width: 180.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "asset/auth/verified.jpg",
                          height: 100,
                        ),
                        Text(
                          "Phone Number\nChanged\nSuccessfully",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 20),
                        )
                      ],
                    )));
          });
    });
  }

  String code;
  @override
  void initState() {
    super.initState();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'asset/ill2.png',
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Enter your code sent at " + widget.phoneNumber,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
PinCodeTextField(
  keyboardType: TextInputType.number,
  appContext: context,
                // textInputType: TextInputType.number,
                length: 6,
                // obsecureText: false,
                animationType: AnimationType.fade,
                // shape: PinCodeFieldShape.underline,
                animationDuration: Duration(milliseconds: 300),
                // fieldHeight: 50,
                // fieldWidth: 35,
                onChanged: (value) {
                  code = value;
                },
              ),
                    SizedBox(
                      height: 32,
                    ),


InkWell(
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
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                              child: Text(
                            "VERIFY",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))),
                      onTap: () async {

                showDialog(
                  builder: (context) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                    return Center(
                        child: CupertinoActivityIndicator(
                      radius: 20,
                    ));
                  },
                  barrierDismissible: false,
                  context: context,
                );
                AuthCredential _phoneAuth = PhoneAuthProvider.credential(
                    verificationId: widget.smsVerificationCode, smsCode: code);
                if (widget.updateNumber) {
                  User user = FirebaseAuth.instance.currentUser;
                  user
                      .updatePhoneNumber(_phoneAuth)
                      .then((_) => updateNumber())
                      .catchError((e) {
                    CustomSnackbar.snackbar("$e", _scaffoldKey);
                  });
                } else {
                  FirebaseAuth.instance
                      .signInWithCredential(_phoneAuth)
                      .then((authResult) {
                    if (authResult != null) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            Future.delayed(Duration(seconds: 2), () async {
                              Navigator.pop(context);
                              await _login.navigationCheck(
                                  authResult.user, context);
                            });
                            return Center(
                                child: Container(
                                    width: 180.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "asset/auth/verified.jpg",
                                          height: 100,
                                        ),
                                        Text(
                                          "Verified\n Successfully",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Colors.black,
                                              fontSize: 20),
                                        )
                                      ],
                                    )));
                          });
                      FirebaseFirestore.instance
                          .collection('Users')
                          .where('userId', isEqualTo: authResult.user.uid)
                          .get()
                          .then((QuerySnapshot snapshot) async {
                        if (snapshot.docs.length <= 0) {
                          await setDataUser(authResult.user);
                        }
                      });
                    }
                  }).catchError((onError) {
                    CustomSnackbar.snackbar("$onError", _scaffoldKey);
                  });
                }

                      }
                    ),



                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),


              
              Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),


              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },

                child: Text(
                "Resend New Code",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                textAlign: TextAlign.center,
              ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
