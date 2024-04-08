import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../util/color.dart';
import 'AllowLocation.dart';

class Job extends StatefulWidget {
  final Map<String, dynamic> userData;
  Job(this.userData);

  @override
  _JobState createState() => _JobState();
}

class _JobState extends State<Job> {
  String job = '';
  String company ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 50),
              child: IconButton(
                  color: secondryColor,
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 25),
              child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 5000),
                  child: Container(
                    height: 42,
                    child: FloatingActionButton.extended(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10,
                      heroTag: UniqueKey(),
                      backgroundColor: Colors.white,
                      onPressed: () {
                                                        Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => AllowLocation(widget.userData)));
                      },
                      label: Text(
                        "Skip..",
                        style: TextStyle(color: primaryColor),
                      ),
                      icon: Icon(
                        Icons.navigate_next,
                        color: primaryColor,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Padding(
                        child: Text(
                          "What do you \ndo for living",
                          style: TextStyle(fontSize: 40),
                        ),
                        padding: EdgeInsets.only(left: 50, top: 120),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      child: TextFormField(
                        style: TextStyle(fontSize: 23),
                        decoration: InputDecoration(
                          hintText: "Add your job",
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          helperText: "This is how it will appear in App.",
                          helperStyle:
                              TextStyle(color: secondryColor, fontSize: 15),
                        ),
                        onChanged: (value) {
                          setState(() {
                            job = value;
                          });
                        },
                      ),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      child: TextFormField(
                        style: TextStyle(fontSize: 23),
                        decoration: InputDecoration(
                          hintText: "Add company..",
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          helperText: "This is how it will appear in App.",
                          helperStyle:
                              TextStyle(color: secondryColor, fontSize: 15),
                        ),
                        onChanged: (value) {
                          setState(() {
                            company = value;
                          });
                        },
                      ),
                    ),
                  ),



                  job.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            primaryColor.withOpacity(.5),
                                            primaryColor.withOpacity(.8),
                                            primaryColor,
                                            primaryColor
                                          ])),
                                  height: MediaQuery.of(context).size.height * .065,
                                  width: MediaQuery.of(context).size.width * .75,
                                  child: Center(
                                      child: Text(
                                    "CONTINUE",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: textColor,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              onTap: () {
                                widget.userData.addAll({'editInfo': {'job_title' : job}});
                                widget.userData.addAll({'editInfo': {'company' : company}});
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => AllowLocation(widget.userData)));
                              },
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  height: MediaQuery.of(context).size.height * .065,
                                  width: MediaQuery.of(context).size.width * .75,
                                  child: Center(
                                      child: Text(
                                    "CONTINUE",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: secondryColor,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              onTap: () {},
                            ),
                          ),
                        )
                ],
              ),
        ),
      ),
    );
  }
}

