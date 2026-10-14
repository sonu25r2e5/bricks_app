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
class Player extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite('ball.png');

    position = game.size / 2;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}

class SpaceShooterGame extends FlameGame with DragCallbacks {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = Player();

    add(player);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    player.move(event.localDelta);
  }
}
