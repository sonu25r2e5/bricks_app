import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final bool isGameOver;

  const new({super.key, required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Container(
            alignment: Alignment(0, -0.3),
            child: Text('U lose bro try next time '),
          )
        : Container();
  }
}
