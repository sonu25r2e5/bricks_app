import 'package:bricks_app/constant/appColor.dart';
import 'package:bricks_app/constant/appimages.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double ballX;
  final double ballY;

  const new({super.key, required this.ballX, required this.ballY});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: AppColor.purple,
          shape: BoxShape.circle,
        ),
        child: Image.asset(Appimages.breakBall),
      ),
    );
  }
}
