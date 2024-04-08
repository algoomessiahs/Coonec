// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../util/color.dart';

class LargeImage extends StatelessWidget {
  final largeImage;
  LargeImage(this.largeImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            //automaticallyImplyLeading: false,
            backgroundColor: primaryColor),
        backgroundColor: Colors.white,
        body: Center(
                child: SingleChildScrollView(
                  child: Image.network(largeImage ?? ''),
                ),
              ),
            );
  }
}
