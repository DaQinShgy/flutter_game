import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_event.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/coin_score.dart';

class PowerupFlower extends SpriteAnimationComponent
    with
        HasGameRef<MarioGame>,
        CollisionCallbacks,
        FlameBlocReader<StatsBloc, StatsState> {
  PowerupFlower({super.position, super.priority = -1});

  List<List<double>> flowerVector = [
    [0, 32, 16, 16],
    [16, 32, 16, 16],
    [32, 32, 16, 16],
    [48, 32, 16, 16],
  ];

  late RectangleHitbox _hitbox;

  @override
  Future<void> onLoad() {
    animation = SpriteAnimation.spriteList(
      flowerVector
          .map((e) => Sprite(
                game.images.fromCache('mario/item_objects.png'),
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: 0.08,
    );

    _hitbox = RectangleHitbox(collisionType: CollisionType.passive);
    add(_hitbox);

    add(MoveByEffect(
      Vector2(0, -16),
      LinearEffectController(0.6),
    ));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MarioPlayer) {
      remove(_hitbox);
      opacity = 0;
      bloc.add(const ScoreMushroom());
      CoinScore coinScore = CoinScore(
        '1000',
        position: Vector2(width / 2, -10),
      );
      add(coinScore);
      coinScore.add(MoveByEffect(
        Vector2(0, -40),
        EffectController(
          duration: 0.5,
        ),
        onComplete: () {
          remove(coinScore);
          removeFromParent();
        },
      ));
    }
  }
}
