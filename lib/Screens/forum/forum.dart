import 'package:flutter/material.dart';

class Forumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: 375,
          height: 812,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Stack(children: <Widget>[
            Positioned(
              top: 25,
              left: 20,
              child: Icon(Icons.arrow_back),
            ),
            Positioned(
                top: 35,
                left: 116,
                child: Text(
                  'For You',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.purple, fontFamily: 'Poppins', fontSize: 14, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 35,
                left: 231,
                child: Text(
                  'Trend',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(9, 9, 9, 1), fontFamily: 'Poppins', fontSize: 14, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(top: 67, left: 109, child: Divider(color: Color.fromRGBO(90, 58, 255, 1), thickness: 1)),
            Positioned(
                top: 207,
                left: 13,
                child: Text(
                  'The King of The Jungle',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 207,
                left: 13,
                child: Text(
                  'The King of The Jungle',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 160,
                left: 13,
                child: Container(
                    width: 33,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(196, 196, 196, 1),
                      borderRadius: BorderRadius.all(Radius.elliptical(33, 34)),
                    ))),
            Positioned(
                top: 160,
                left: 13,
                child: Container(
                    width: 33,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(196, 196, 196, 1),
                      borderRadius: BorderRadius.all(Radius.elliptical(33, 34)),
                    ))),
            Positioned(
                top: 160,
                left: 58,
                child: Text(
                  'Haven Clan',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 14, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 160,
                left: 58,
                child: Text(
                  'Haven Clan',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 14, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 179,
                left: 58,
                child: Text(
                  'Posted by Keeneth',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(182, 179, 179, 1), fontFamily: 'Poppins', fontSize: 13, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 179,
                left: 58,
                child: Text(
                  'Posted by Keeneth',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(182, 179, 179, 1), fontFamily: 'Poppins', fontSize: 13, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 67,
                left: 0,
                child: Container(
                    width: 375,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))),
            Positioned(
                top: 520,
                left: 0,
                child: Container(
                    width: 375,
                    height: 29,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 229, 229, 1),
                    ))),
            Positioned(
                top: 80,
                left: 23,
                child: Text(
                  'HOT POSTS',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5199999809265137), fontFamily: 'Poppins', fontSize: 14, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(top: 67, left: 0, child: Divider(color: Color.fromRGBO(0, 0, 0, 1), thickness: 1)),
            Positioned(
                top: 160,
                left: 327,
                child: Text(
                  'Join',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 160,
                left: 327,
                child: Text(
                  'Join',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 239,
                left: -3,
                child: Container(
                    width: 377,
                    height: 212.0625,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage('https://img.republicworld.com/republic-prod/stories/promolarge/xhdpi/77foofn8su54mply_1596690894.jpeg'), fit: BoxFit.fitWidth),
                    ))),
            Positioned(
              top: 474,
              left: 29,
              child: Icon(Icons.arrow_downward),
            ),
            Positioned(
              top: 474,
              left: 123,
              child: Icon(Icons.arrow_downward),
            ),
            Positioned(
                top: 476,
                left: 54,
                child: Text(
                  '25K',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 476,
                left: 234,
                child: Text(
                  '259',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 476,
                left: 321,
                child: Text(
                  'Share',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 476,
                left: 321,
                child: Text(
                  'Share',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 476,
                left: 147,
                child: Text(
                  '1.2K',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 476,
                left: 147,
                child: Text(
                  '1.2K',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 637,
                left: 13,
                child: Text(
                  'SAO is the best Anime EVER',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 590,
                left: 13,
                child: Container(
                    width: 33,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(196, 196, 196, 1),
                      borderRadius: BorderRadius.all(Radius.elliptical(33, 34)),
                    ))),
            Positioned(
                top: 590,
                left: 58,
                child: Text(
                  'Nice Group',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 14, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 609,
                left: 58,
                child: Text(
                  'Posted by Jaccy',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(182, 179, 179, 1), fontFamily: 'Poppins', fontSize: 13, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 590,
                left: 327,
                child: Text(
                  'Join',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 685,
                left: 48,
                child: Text(
                  '965',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(top: 687, left: 234, child: Icon(Icons.message)),
            Positioned(
                top: 687,
                left: 234,
                child: Text(
                  '259',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 686,
                left: 315,
                child: Text(
                  'Share',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
            Positioned(
                top: 685,
                left: 141,
                child: Text(
                  '100K',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Poppins', fontSize: 15, letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/, fontWeight: FontWeight.normal, height: 1),
                )),
          ]),
        ),
      ),
    );
  }
}
