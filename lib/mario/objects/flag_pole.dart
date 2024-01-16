import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';

class Pole extends SpriteComponent
    with HasGameRef<MarioGame>, CollisionCallbacks {
  Pole({super.position});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('mario/tile_set.png'),
      srcPosition: Vector2(263, 144),
      srcSize: Vector2(2, 16),
    );
    add(RectangleHitbox());
    return super.onLoad();
  }
}

class Flag extends SpriteComponent
    with
        HasGameRef<MarioGame>,
        CollisionCallbacks,
        FlameBlocListenable<StatsBloc, StatsState> {
  Flag({super.position});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('mario/item_objects.png'),
      srcPosition: Vector2(128, 32),
      srcSize: Vector2(16, 16),
    );
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onNewState(StatsState state) {
    if (state.status == GameStatus.victory) {
      add(MoveToEffect(Vector2(x, 168), EffectController(duration: 0.5)));
    }
    super.onNewState(state);
  }
}

class Finial extends SpriteComponent
    with HasGameRef<MarioGame>, CollisionCallbacks {
  Finial({super.position});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('mario/tile_set.png'),
      srcPosition: Vector2(228, 120),
      srcSize: Vector2(8, 8),
    );
    add(RectangleHitbox());
    return super.onLoad();
  }
}
