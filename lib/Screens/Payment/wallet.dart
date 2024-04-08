import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool isCoo = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 35),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('asset/wall.png'),
                        )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "cooWallet",
                        style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w800),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Wallet Overview",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, fontFamily: 'avenir'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xfff1f3f6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCoo ? "0" : "0",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          isCoo ? "Coo-Coin Balance" : "Bean-Coing Balance",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(
                          isCoo ? Icons.switch_right : Icons.switch_left,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            isCoo = !isCoo;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recently Gifted",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, fontFamily: 'avenir'),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/images/scanqr.png'))),
                  )
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Container(
                    //   height: 70,
                    //   width: 70,
                    //   margin: EdgeInsets.only(right: 20),
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Color(0xffffac30),
                    //   ),
                    //   child: Icon(
                    //     Icons.add,
                    //     size: 40,
                    //   ),
                    // ),
                    avatarWidget("https://ar.toneden.io/27742733/tracks/temp330341?cache=1592646725383", "Test"),
                    avatarWidget("https://i.redd.it/g41yp9cc3wo51.jpg", "Test2"),
                    avatarWidget("https://fashionsista.co/downloadpng/png/20201007/anime-kawaii-girls-anime-amino.jpg", "Test3"),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Services',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, fontFamily: 'avenir'),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    child: Icon(Icons.dialpad),
                  )
                ],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 0.7,
                  children: [
                    serviceWidget("lo.png", "Load\nFund"),
                    serviceWidget("wit.png", "Withdraw\nFund"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column serviceWidget(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('asset/$img'))),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Container avatarWidget(String img, String name) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 150,
      width: 120,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xfff1f3f6)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, image: DecorationImage(image: NetworkImage(img), fit: BoxFit.contain), border: Border.all(color: Colors.black, width: 2)),
          ),
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
