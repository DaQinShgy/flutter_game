import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_event.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';
import 'package:flutter_game/tetris/tetris_game.dart';

class IconTrumpet extends SpriteComponent with HasGameRef<TetrisGame>, FlameBlocReader<StatsBloc, StatsState> {
  IconTrumpet({super.position}) : super(size: Vector2(18, 14));

  late Sprite spriteValid;

  late Sprite spriteInvalid;

  @override
  Future<void> onLoad() {
    spriteValid = Sprite(
      game.images.fromCache('tetris.png'),
      srcPosition: Vector2(150, 75),
      srcSize: Vector2(25, 21),
    );
    spriteInvalid = Sprite(
      game.images.fromCache('tetris.png'),
      srcPosition: Vector2(175, 75),
      srcSize: Vector2(25, 21),
    );
    sprite = spriteInvalid;
    return super.onLoad();
  }

  bool firstUpdate = true;

  @override
  void update(double dt) {
    if (firstUpdate) {
      firstUpdate = false;
      bloc.on<Mute>((event, emit) {
        emit(bloc.state.copyWith(mute: !bloc.state.mute));
        sprite = bloc.state.mute ? spriteValid : spriteInvalid;
      });
    }
  }
}
