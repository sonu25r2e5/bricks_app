import 'dart:async';

import 'package:bricks_app/actors/enemy.dart';
import 'package:bricks_app/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;
  final Player player;
  // createa a constructuor
  Level({required this.levelName, required this.player});

  // it comes from flame compoents
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    // we need to grab the lvels and creating the compontest
    level = await TiledComponent.load('$levelName.tmx', Vector2(16, 16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          // final player = Player(position: Vector2(spawnPoint.x, spawnPoint.y));
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
