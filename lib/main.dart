import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

// class Player extends PositionComponent {
//   static final _point = Paint()..color = Colors.white;

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     canvas.drawRect(
//       Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
//       _point,
//     );
//   }

//   // for moving the object we use this. one.
//   void move(Vector2 delta) {
//     position.add(delta);
//   }
// }
// class Player extends SpriteComponent with HasGameReference {
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     sprite = await game.loadSprite('ball.png');

//     position = game.size / 2;
//   }

//   void move(Vector2 delta) {
//     position.add(delta);
//   }
// }

class SpaceShooterGame extends FlameGame with DragCallbacks {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    images.prefix = 'assets/';
    player = Player();
    add(player);
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
    // TODO: implement onDragEnd
    super.onDragEnd(event);
    player.stopShooting();
  }
}

class Player extends SpriteComponent with HasGameReference<SpaceShooterGame> {
  Player() : super(size: Vector2(100, 27), anchor: Anchor.center);

  late final SpawnComponent _bulletSpawner;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _bulletSpawner = SpawnComponent(
      period: .2,
      selfPositioning: true,
      factory: (index) {
        return Bullet(position: position + Vector2(0, -height / 2 - 10));
      },
      autoStart: false,
    );
    game.add(_bulletSpawner);

    sprite = await game.loadSprite('player_title.png');
    position = Vector2(game.size.x / 2, game.size.y - height);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
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
    sprite = await game.loadSprite('images/breakout.png');
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
