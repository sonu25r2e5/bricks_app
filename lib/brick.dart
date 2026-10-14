import 'package:bricks_app/constant/appimages.dart';
import 'package:flutter/material.dart';

class Brick extends StatelessWidget {
  final firstBrickX;
  final firstBrickY;
  final brickheight;
  final brickwidth;
  final bool brickBroken; // for broken broken downl we use ths one

  const new({
    super.key,
    required this.brickheight,
    required this.brickwidth,
    required this.firstBrickX,
    required this.firstBrickY,
    required this.brickBroken,
  });

  @override
  Widget build(BuildContext context) {
    return brickBroken
        ? Container()
        : Container(
            alignment: Alignment(firstBrickX, firstBrickY),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: MediaQuery.of(context).size.height * brickheight / 2,
                width: MediaQuery.of(context).size.width * brickwidth / 2,
                // color: Colors.deepPurple,
                child: Image.asset(Appimages.breakout),
              ),
            ),
          );
  }
}
