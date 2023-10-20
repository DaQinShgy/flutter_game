import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';
import 'package:flutter_game/tetris/tetris_game.dart';

class IconPause extends SpriteComponent
    with HasGameRef<TetrisGame>, FlameBlocListenable<StatsBloc, StatsState> {
  IconPause({super.position}) : super(size: Vector2(18, 14));

  late Sprite spriteValid;

  late Sprite spriteInvalid;

  @override
  FutureOr<void> onLoad() {
    spriteValid = Sprite(
      game.images.fromCache('tetris/tetris.png'),
      srcPosition: Vector2(75, 75),
      srcSize: Vector2(25, 21),
    );
    spriteInvalid = Sprite(
      game.images.fromCache('tetris/tetris.png'),
      srcPosition: Vector2(100, 75),
      srcSize: Vector2(25, 21),
    );
    sprite = spriteValid;
  }

  @override
  void onNewState(StatsState state) {
    if (state.status == GameStatus.running) {
      sprite = spriteInvalid;
    } else if (state.status == GameStatus.pause) {
      sprite = spriteValid;
    }
  }
}
