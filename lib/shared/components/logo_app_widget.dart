//core and pub package
import 'package:flutter/material.dart';

class LogoAppWidget extends StatelessWidget {
  final String imagePath;
  final double width, height;
  const LogoAppWidget({
    Key key,
    this.imagePath = "assets/images/crowd.png",
    this.width = 0.7,
    this.height = 0.2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage(
        imagePath,
      ))),
    );
  }
}
