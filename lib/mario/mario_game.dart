import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/objects/game_background.dart';
import 'package:flutter_game/mario/overlays/hud.dart';

class MarioGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final CameraComponent cameraComponent;

  late final double scaleSize;

  late final TiledComponent mapComponent;

  late MarioPlayer _marioPlayer;

  late Component _gameBackground;

  MarioPlayer get marioPlayer => _marioPlayer;

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

    mapComponent = await TiledComponent.load(
      'mario.tmx',
      Vector2.all(8),
    );

    scaleSize = size.y / mapComponent.height;

    cameraComponent.viewfinder
      ..zoom = scaleSize
      ..anchor = Anchor.topLeft;
    await add(
      FlameBlocProvider<StatsBloc, StatsState>(
        create: () => StatsBloc(),
        children: [cameraComponent, world],
      ),
    );
    _marioPlayer = MarioPlayer(
      position: Vector2(32, ObjectValues.groundY),
    );
    _gameBackground = GameBackground();
    world.addAll([_gameBackground, mapComponent, _marioPlayer]);

    cameraComponent.viewport.add(Hub(size: size));
  }

  @override
  Color backgroundColor() => Colors.black;

  void resetView() {
    world.removeAll([_gameBackground, _marioPlayer]);
    _marioPlayer = MarioPlayer(
      position: Vector2(32, ObjectValues.groundY),
    );
    _gameBackground.removeAll(_gameBackground.children);
    _gameBackground = GameBackground();
    world.addAll([_gameBackground, _marioPlayer]);
    cameraComponent.viewfinder.position = Vector2(0, 0);
  }
}
