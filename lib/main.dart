import 'dart:async';

import 'package:bricks_app/actors/player.dart';
import 'package:bricks_app/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  // widget fluttering binding.
  WidgetsFlutterBinding.ensureInitialized();
  // flame fullscreen // if you install on the physical device than it will not work complete
  // so it ttakes time so fix it and wait and set to fullscreen and build a name.
  // it takes hr for developer to fix itt so be thankful okay .
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  PixelAdventure game = PixelAdventure();
  runApp(GameWidget(game: game));
}

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  // if you want ot add color
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  // declaring the game yhou want to have.
  late final CameraComponent cam;
  // just initalized the player
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joystick;

  // add(Level());
  @override
  FutureOr<void> onLoad() async {
    // waiting the image
    // load most of images and later you can use it. ladeter
    await images.loadAllImages();
    // it will help to initialized the player nothing more than that. hehehe
    final world = Level(player: player, levelName: 'level-01');

    cam = CameraComponent.withFixedResolution(
      world: world,
      height: 400,
      width: 640,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    addJoyStick();
    return super.onLoad();
  }

  void addJoyStick() {
    // adding joystick file here.
    joystick = JoystickComponent(
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/knob.png'))),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      knobRadius: 32,
      margin: EdgeInsets.only(left: 42, bottom: 42),
    );
    add(joystick);
  }
}
