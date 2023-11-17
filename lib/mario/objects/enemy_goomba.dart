import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/coin_score.dart';

class EnemyGoomba extends SpriteAnimationComponent
    with
        HasGameRef<MarioGame>,
        CollisionCallbacks,
        FlameBlocReader<StatsBloc, StatsState> {
  EnemyGoomba(this.name, {super.position});

  final String name;

  List<List<double>> walkVector = [
    [0, 4, 16, 16],
    [30, 4, 16, 16],
  ];

  List<List<double>> killVector = [
    [60, 8, 16, 7],
  ];

  late RectangleHitbox _hitbox;

  @override
  Future<void> onLoad() {
    animation = _getAnimation(walkVector);
    _hitbox = RectangleHitbox();
    add(_hitbox);
    return super.onLoad();
  }

  SpriteAnimation _getAnimation(List<List<double>> list) {
    return SpriteAnimation.spriteList(
      list
          .map((e) => Sprite(
                game.images.fromCache('mario/smb_enemies_sheet.png'),
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: 0.1,
    );
  }

  int horizontalDirection = 0;

  double moveSpeed = 0;

  bool killed = false;

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.status != GameStatus.running) {
      playing = false;
      return;
    }
    if (killed) {
      return;
    }
    double screenWidth = game.size.x / game.scaleSize;
    if (game.cameraComponent.viewfinder.position.x + screenWidth >= x &&
        horizontalDirection == 0) {
      horizontalDirection = -1;
      moveSpeed = ObjectValues.enemyMoveSpeed;
      if (name.isNotEmpty) {
        parent?.children
            .where((element) => element is EnemyGoomba && element.name == name)
            .forEach((element) => (element as EnemyGoomba).runParallel());
      }
    }
    x += moveSpeed * horizontalDirection * dt;
    if (x + width < game.cameraComponent.viewfinder.position.x) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MarioPlayer) {
      if (other.isSmall && !other.invisibility) {
        killed = true;
      }
    } else {
      horizontalDirection = -horizontalDirection;
    }
  }

  void squishes() {
    y += 9;
    animation = _getAnimation(killVector);
    remove(_hitbox);

    CoinScore coinScore = CoinScore(
      '100',
      position: Vector2(width / 2, -10),
    );
    add(coinScore);
    coinScore.add(MoveByEffect(
      Vector2(0, -24),
      EffectController(
        duration: 0.4,
      ),
      onComplete: () {
        remove(coinScore);
      },
    ));
    add(RemoveEffect(delay: 0.5));
  }

  runParallel() {
    if (horizontalDirection != 0) {
      return;
    }
    horizontalDirection = -1;
    moveSpeed = ObjectValues.enemyMoveSpeed;
  }
}
