import 'package:bricks_app/constant/appimages.dart';
import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  // for controlling the x-co-ordinate and y-co-ordinate
  final double playerX;
  final double playerWidth;

  const new({super.key, required this.playerX, required this.playerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      // for indication the direction of the player we use this one. nothign more than that.
      alignment: Alignment(
        (2 * playerX + playerWidth) / (2 - playerWidth),
        0.9,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width * playerWidth / 2,
          // color: Colors.red,
          child: Image.asset(Appimages.breaktitle),
        ),
      ),
    );
  }
}
