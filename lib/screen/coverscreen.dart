import 'package:flutter/material.dart';

class Coverscreen extends StatelessWidget {
  // we place bool here.
  final bool hasGameStarted;

  const new({super.key, required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    // use ternary oeperator conditoikn here.
    return hasGameStarted
        ? Container(color: Colors.grey)
        : Container(
            alignment: Alignment(0, -0.2),
            child: Text(
              'tap to play',
              style: TextStyle(color: Colors.deepPurpleAccent),
            ),
          );
  }
}
