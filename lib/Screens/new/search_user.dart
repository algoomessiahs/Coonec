import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("Users");
  @override
  void initState() {
    _getuserList();
    super.initState();
  }

  TextEditingController searchctrlr = TextEditingController();
  bool isLargeScreen = false;

  int totalDoc;
  DocumentSnapshot lastVisible;
  int documentLimit = 25;
  List<AUser> user = [];
  bool sort = true;
  // int start = 0;
  // int end = 25;
  Future _getuserList() async {
    collectionReference
        .orderBy("user_DOB", descending: true)
        .get()
        .then((value) {
      totalDoc = value.docs.length;
    });
  }

  Widget userlists(List<AUser> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ListView.builder(itemCount: list.length,itemBuilder: (ctx, i) => Container(
                  child: Text(list[i].name),
                )),
                // DataTable(
                //   sortAscending: sort,
                //   sortColumnIndex: 2,
                //   columnSpacing: MediaQuery.of(context).size.width * .085,
                //   columns: [
                //     DataColumn(
                //       label: Text("Images"),
                //     ),
                //     DataColumn(
                //       label: Text("Name"),
                //     ),
                //     DataColumn(
                //         label: Text("Gender"),
                //         onSort: (columnIndex, ascending) {
                //           setState(() {
                //             sort = !sort;
                //           });
                //           onSortColum(columnIndex, ascending);
                //         }),
                //     DataColumn(label: Text("Phone Number")),
                //     DataColumn(label: Text("User_id")),
                //     DataColumn(label: Text("view")),
                //   ],
                //   rows: list
                //       .getRange(
                //           list.length >= documentLimit
                //               ? list.length - documentLimit
                //               : 0,
                //           list.length)
                //       .map(
                //         (index) => DataRow(cells: [
                //           DataCell(
                //             ClipRRect(
                //               borderRadius: BorderRadius.circular(18),
                //               child: CircleAvatar(
                //                 child: index.imageUrl[0] != null
                //                     ? Image.network(
                //                         index.imageUrl[0],
                //                         fit: BoxFit.fill,
                //                         errorBuilder: (BuildContext context,
                //                             Object exception,
                //                             StackTrace stackTrace) {
                //                           return Text('');
                //                         },
                //                       )
                //                     : Container(),
                //                 backgroundColor: Colors.grey,
                //                 radius: 18,
                //               ),
                //             ),
                //             // onTap: () {
                //             //   // write your code..
                //             // },
                //           ),
                //           DataCell(
                //             Text(index.name),
                //           ),
                //           DataCell(
                //             Text(index.gender),
                //           ),
                //           DataCell(
                //             Text(index.phoneNumber),
                //           ),
                //           DataCell(
                //             Row(
                //               children: [
                //                 Container(
                //                   width: 150,
                //                   child: Text(
                //                     index.id,
                //                     overflow: TextOverflow.ellipsis,
                //                   ),
                //                 ),
                //                 IconButton(
                //                     icon: Icon(
                //                       Icons.content_copy,
                //                       size: 20,
                //                     ),
                //                     tooltip: "copy",
                //                     onPressed: () {
                //                       Clipboard.set(ClipboardData(
                //                         text: index.id,
                //                       ));
                //                     })
                //               ],
                //             ),
                //           ),
                //           DataCell(
                //             IconButton(
                //                 icon: Icon(Icons.fullscreen),
                //                 tooltip: "open profile",
                //                 onPressed: () async {
                //                   // var _isdelete = await Navigator.push(
                //                   //     context,
                //                   //     MaterialPageRoute(
                //                   //         builder: (context) => Info(index)));
                //                     setState(() {
                //                       searchctrlr.clear();
                //                       searchReasultfuture = null;
                //                       user.removeWhere(
                //                           (element) => element.id == index.id);
                //                     });
                //                 }),
                //           ),
                //         ]),
                //       )
                //       .toList(),
                // ),
              ),
            ),
            searchReasultfuture != null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 12,
                            ),
                            onPressed: () {
                              setState(() {
                                if (list.length > documentLimit) {
                                  list.removeRange(
                                    list.length - documentLimit,
                                    list.length,
                                  );
                                }
                              });
                            }),
                        Text(
                            "${list.length >= documentLimit ? list.length - documentLimit : 0}-${list.length - 1} of $totalDoc  "),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  _getuserList()
                                      .then((value) => Navigator.pop(context));
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        )
                      ],
                    ),
                  )
          ],
        ));
  }

  List<AUser> results = [];
  Future<QuerySnapshot> searchReasultfuture;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  searchuser(String query) {
    if (query.trim().length > 0) {
      Future<QuerySnapshot> users = collectionReference
          .where(
            isNumeric(query) ? 'phoneNumber' : 'UserName',
            isEqualTo: query,
          )
          .get();

      setState(() {
        searchReasultfuture = users;
      });
    }
  }

  Widget buildSearchresults() {
    return FutureBuilder(
      future: searchReasultfuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                )),
              ),
              Text("Searching......"),
            ],
          );
          //
        }
        // if (snapshot.datadocs.length > 0) {
        //   results.clear();
        //   snapshot.datadocs.forEach((DocumentSnapshot doc) {
        //     if (doc.data.length > 0) {
        //       User usert2 = User.fromDocument(doc);
        //       results.add(usert2);
        //     }
        //   });
        //   return userlists(results);
        // }
        return Center(child: Text("no data found"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Users",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.white)),
                    height: 4,
                    width: isLargeScreen
                        ? MediaQuery.of(context).size.width * .3
                        : MediaQuery.of(context).size.width * .5,
                    child: Card(
                      child: TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        controller: searchctrlr,
                        decoration: InputDecoration(
                            hintText: "Search user number or name!",
                            filled: true,
                            prefixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () => searchuser(searchctrlr.text)),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchctrlr.clear();
                                setState(() {
                                  searchReasultfuture = null;
                                });
                              },
                            )),
                        onFieldSubmitted: searchuser,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: searchReasultfuture == null
                ? user.length > 0
                    ? userlists(user)
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      )))
                : buildSearchresults(),
          );
  }




  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 2) {
      if (ascending) {
        user.sort((a, b) => a.gender.compareTo(b.gender));
      } else {
        user.sort((a, b) => b.gender.compareTo(a.gender));
      }
    }
  }
}
