import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/objects/game_background.dart';

class MarioGame extends FlameGame with HasKeyboardHandlerComponents {
  late final CameraComponent cameraComponent;

  late final double backgroundHeight;

  late final double groundHeight;

  late final double unitSize;

  late final MarioPlayer _marioPlayer;

  double objectSpeed = 0.0;

  @override
  final world = World();

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'mario_bros.png',
      'mario_enemies.png',
      'mario_item_objects.png',
      'mario_level_1.png',
      'mario_smb_enemies_sheet.png',
      'mario_text_images.png',
      'mario_tile_set.png',
      'mario_title_screen.png',
    ]);
    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, world]);

    initializeGame();
  }

  @override
  Color backgroundColor() => Colors.black;

  void initializeGame() {
    backgroundHeight = size.y * 0.9;
    unitSize = backgroundHeight / 224;
    groundHeight = backgroundHeight - 24 * unitSize;
    add(GameBackground(
      size: Vector2(
        unitSize * 3392,
        backgroundHeight,
      ),
    ));
    _marioPlayer = MarioPlayer(
      position: Vector2(32 * unitSize, groundHeight),
    );
    world.add(_marioPlayer);
    // if (loadHub) {
    //   cameraComponent.viewport.add(Hub());
    // }
  }
}
