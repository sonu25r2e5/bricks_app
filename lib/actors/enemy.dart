import 'dart:async';

import 'package:bricks_app/main.dart';
import 'package:flame/components.dart';

enum EnemyState { idle, running }

class Enemy extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure> {
  String character;
  Enemy({required this.character});

  late final SpriteAnimation idleAnimation;
  // final animation
  late final SpriteAnimation runningAnimation;

  final double stepTime = 0.05;
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    super.onLoad();
  }

  void _loadAllAnimation() {
    // spresetinon

    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/Idle (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: 4, // amount of the data to be used.
        stepTime: stepTime,
        textureSize: Vector2(29, 29),
      ),
    );

    // running animation
    runningAnimation = spriteAniamtionRunning('Idle');
    // running animation

    // lsit of all animation that should include.
    animations = {
      EnemyState.idle: idleAnimation,
      EnemyState.running: runningAnimation,
    };

    // set a current Animations
    current = EnemyState.running;
  }

  SpriteAnimation spriteAniamtionRunning(String state) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: 12, // amount of the data to be used.
        stepTime: stepTime,
        textureSize: Vector2(11, 11),
      ),
    );
  }
}
