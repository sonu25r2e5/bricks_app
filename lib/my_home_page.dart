import 'dart:async';

import 'package:bricks_app/brick.dart';
import 'package:bricks_app/gameoverscreen.dart';
import 'package:bricks_app/screen/ball.dart';
import 'package:bricks_app/constant/app_color.dart';
import 'package:bricks_app/screen/coverscreen.dart';
import 'package:bricks_app/screen/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// create a bariavble of constant.
enum Direction { up, down, left, right }

class _HomePageState extends State<HomePage> {
  // we create a two variable inlcude
  double ballX = 0;
  double ballY = 0;

  double ballXincrments = 0.02;
  double ballYincrements = 0.02;

  // assign ball direction
  var ballYDirection = Direction.down;
  var ballXDirection = Direction.left;

  // player variable
  double playerX = -0.2;
  double playerWidth = 0.4;

  // game setting lies here.
  bool hasGameStared = false;
  bool isGameOver = false;

  static const int brickColumns = 5;
  static const int brickRows = 5;
  static const double brickWidth = 0.32;
  static const double brickHeight = 0.1;
  static const double brickColumnSpacing = 0.4;
  static const double brickRowSpacing = 0.19;
  static const double firstBrickY = -0.88;

  final List<Offset> bricks = List.generate(brickColumns * brickRows, (index) {
    final row = index ~/ brickColumns;
    final column = index % brickColumns;
    final firstBrickX = -((brickColumns - 1) * brickColumnSpacing) / 2;
    return Offset(
      firstBrickX + column * brickColumnSpacing,
      firstBrickY + row * brickRowSpacing,
    );
  });
  final Set<int> brokenBricks = {};

  // for starting the game we make the function
  void startGame() {
    hasGameStared = true;
    // we start teh game we ane we introduce the game here. and tehre., that's all nothign more thank that.
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      updateDirection();
      // for update the direction
      moveBall();

      // check if player is Dead
      if (isPlayerDead()) {
        // add some comment on it.
        timer.cancel();
        isGameOver = true;
      }

      // what if bricks got broken than what shall we done
      checkForBrokenBricks();
    });
  }

  void checkForBrokenBricks() {
    if (ballYDirection != Direction.up) {
      return;
    }

    for (var index = 0; index < bricks.length; index++) {
      if (brokenBricks.contains(index)) {
        continue;
      }

      final brick = bricks[index];
      final overlapsBrick =
          ballX >= brick.dx - brickWidth / 2 &&
          ballX <= brick.dx + brickWidth / 2 &&
          ballY >= brick.dy - brickHeight / 2 &&
          ballY <= brick.dy + brickHeight / 2;

      if (overlapsBrick) {
        setState(() {
          brokenBricks.add(index);
          ballYDirection = Direction.down;
        });
        break;
      }
    }
  }

  bool isPlayerDead() {
    // if player is dead then we cancel the game
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  // for moving left and right

  void moveLeft() {
    // for palcing the ball we look ehere
    setState(() {
      // we use condition for moving the the edge not out of sthe screen.
      if (!(playerX - 0.2 < -1)) {
        playerX -= 0.2;
      }
      // playerX
    });
  }

  void moveRight() {
    setState(() {
      // for moving right handside we look this equation
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.2;
      }
    });
  }

  void moveBall() {
    setState(() {
      // applying horizontally
      // for moving the direction of the ball we amply it.
      if (ballXDirection == Direction.left) {
        // if the direction is up we move i mean i just add
        ballX -= ballXincrments;
      } else if (ballXDirection == Direction.right) {
        // if the direction is down then i just subtarct it. nothing more than that.
        ballX += ballXincrments;
      }

      // applying vertically
      // for moving the direction of the ball we amply it.
      if (ballYDirection == Direction.down) {
        // if the direction is up we move i mean i just add
        ballY += ballYincrements;
      } else if (ballYDirection == Direction.up) {
        // if the direction is down then i just subtarct it. nothing more than that.
        ballY -= ballYincrements;
      }
    });
  }

  void updateDirection() {
    /// mvoing teh ball
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = Direction.up;
      } else if (ballY <= -1) {
        ballYDirection = Direction.down;
      }

      // for left and right
      if (ballX >= 1) {
        ballXDirection = Direction.left;
      } else if (ballX <= -1) {
        ballXDirection = Direction.right;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          // move left
          moveLeft();
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          moveRight(); // for moving the edge we prevent from moving out of the box. we use this. one.
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: AppColor.white,
          body: Center(
            child: Stack(
              children: [
                // cover screen lies here.
                Coverscreen(hasGameStarted: hasGameStared),
                // ball Screen.
                MyBall(ballX: ballX, ballY: ballY),
                // player
                MyPlayer(playerX: playerX, playerWidth: playerWidth),
                for (var index = 0; index < bricks.length; index++)
                  Brick(
                    firstBrickX: bricks[index].dx,
                    firstBrickY: bricks[index].dy,
                    brickheight: brickHeight,
                    brickwidth: brickWidth,
                    brickBroken: brokenBricks.contains(index),
                  ),

                // Gameover Screen nothing more than that.
                GameOverScreen(isGameOver: isGameOver),

                // // where is x codiddrainate for illustartion
                // Container(
                //   alignment: Alignment(playerX, 0.9),
                //   child: Container(color: Colors.green, width: 4, height: 15),
                // ),
                // // right side width we calculate here.
                // Container(
                //   alignment: Alignment(playerX + playerWidth, 0.9),
                //   child: Container(color: Colors.green, width: 4, height: 15),
                // ),

                // have the snse of the tdirection
              ],
            ),
          ),
        ),
      ),
    );
  }
}
