import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

class SpaceShooterGame extends FlameGame
    with DragCallbacks, HasCollisionDetection {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images.prefix = 'assets/';
    player = Player();
    add(player);

    add(
      SpawnComponent(
        factory: (index) => Enemy(),
        period: 1,
        area: Rectangle.fromLTWH(0, -Enemy.enemySize, size.x, Enemy.enemySize),
      ),
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    player.move(event.localDelta);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    player.startShooting();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    player.stopShooting();
  }
}

class Player extends SpriteComponent with HasGameReference<SpaceShooterGame> {
  Player() : super(size: Vector2(100, 27), anchor: Anchor.center);

  static const _shootInterval = 0.2;
  bool _isShooting = false;
  double _shootElapsed = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite('player_title.png');
    position = Vector2(game.size.x / 2, game.size.y - height);
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  void startShooting() {
    if (_isShooting) return;

    _isShooting = true;
    _shootElapsed = 0;
    _fireBullet();
  }

  void stopShooting() {
    _isShooting = false;
    _shootElapsed = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_isShooting) return;

    _shootElapsed += dt;
    while (_shootElapsed >= _shootInterval) {
      _shootElapsed -= _shootInterval;
      _fireBullet();
    }
  }

  void _fireBullet() {
    game.add(Bullet(position: position + Vector2(0, -height / 2 - 10)));
  }

  void move(Vector2 delta) {
    position.x = (position.x + delta.x)
        .clamp(width / 2, game.size.x - width / 2)
        .toDouble();
    position.y = (position.y + delta.y)
        .clamp(height / 2, game.size.y - height / 2)
        .toDouble();
  }
}

class Bullet extends SpriteComponent with HasGameReference<SpaceShooterGame> {
  Bullet({super.position})
    : super(size: Vector2.all(20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('ball.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= dt * 500;

    if (position.y < -height / 2) {
      removeFromParent();
    }
  }
}

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  Enemy({super.position}) : super(size: Vector2.all(enemySize));
  static const enemySize = 48.0;

  // other methods for omitted.

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
      game.add(Explosion(position: position));
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // for sprite to load on th escreen

    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(16, 16),
      ),
    );

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 50;
    if (position.y > game.size.y) {
      removeFromParent();
    }
  }
}

class Explosion extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  Explosion({super.position})
    : super(
        size: Vector2.all(150),
        anchor: Anchor.center,
        removeOnFinish: true,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // animation
    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: .1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }
}
