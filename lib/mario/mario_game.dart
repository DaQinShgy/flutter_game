import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/objects/game_background.dart';
import 'package:flutter_game/mario/overlays/hud.dart';

class MarioGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
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
      'mario/mario_bros.png',
      'mario/enemies.png',
      'mario/item_objects.png',
      'mario/level_1.png',
      'mario/smb_enemies_sheet.png',
      'mario/text_images.png',
      'mario/tile_set.png',
      'mario/title_screen.png',
    ]);
    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    await add(
      FlameBlocProvider<StatsBloc, StatsState>(
        create: () => StatsBloc(),
        children: [cameraComponent, world, initializeGame()],
      ),
    );
  }

  @override
  Color backgroundColor() => Colors.black;

  Component initializeGame() {
    backgroundHeight = size.y * 0.9;
    unitSize = backgroundHeight / 224;
    groundHeight = backgroundHeight - 24 * unitSize;
    _marioPlayer = MarioPlayer(
      position: Vector2(32 * unitSize, groundHeight),
    );
    world.add(_marioPlayer);
    cameraComponent.viewport.add(Hub(size: size));
    return GameBackground(
      size: Vector2(
        unitSize * 3392,
        backgroundHeight,
      ),
    );
  }
}
