import 'dart:async';

import 'package:bricks_app/main.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';

// creating a enum for a class
enum PlayerState { idle, running }

enum PlayerDirection { right, left, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<SpaceShooterGame>, KeyboardHandler {
  Player({position, this.character = 'Ninja Frog'}) : super(position: position);

  PlayerDirection playerDirection = PlayerDirection.none;
  // mesuring speed we know.
  double moveSpeed = 100;
  // changing the position
  Vector2 velocity = Vector2.zero();
  // isFacing right to check the direction of the sprite
  bool isFacingRight = true;
  //we need group group componenet. s
  String character;

  late final SpriteAnimation idleAnimation;
  // final animation
  late final SpriteAnimation runningAnimation;

  // make a stepTime for a game

  final double stepTime = 0.09;

  // we update the value
  @override
  void update(double dt) {
    // TODO: implement update
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // key pressed vairahble are made here.
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // when we pressed the key then it goes left and right.
    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }

    // TODO: implement onKeyEvent
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    super.onLoad();
  }

  void _loadAllAnimation() {
    // spresetinon

    idleAnimation = _spriteAniamtionRunning('Idle', 2);

    // running animation
    runningAnimation = _spriteAniamtionRunning('Run', 4);

    // lsit of all animation that should include.
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    // set a current Animations
    current = PlayerState.idle;
  }

  // sprite variable
  SpriteAnimation _spriteAniamtionRunning(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount, // amount of the data to be used.
        stepTime: stepTime,
        textureSize: Vector2(32, 32),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontally();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          // flipHorizionatally
          flipHorizontally();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt; // it will show slows and move with small speed for the sprite tto go alnong on the screen nothing more than that.
  }
}
