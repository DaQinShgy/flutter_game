import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';

class CastleFlag extends SpriteComponent
    with
        HasGameRef<MarioGame>,
        CollisionCallbacks,
        FlameBlocListenable<StatsBloc, StatsState> {
  CastleFlag({super.position});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('mario/item_objects.png'),
      srcPosition: Vector2(129, 2),
      srcSize: Vector2(14, 14),
    );
    opacity = 0;
    return super.onLoad();
  }

  @override
  void onNewState(StatsState state) {
    super.onNewState(state);
    if (state.finish) {
      opacity = 1;
      add(MoveByEffect(
        Vector2(0, -14),
        EffectController(duration: 0.5),
      ));
    }
  }
}
