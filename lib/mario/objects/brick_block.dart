import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_game/mario/mario_game.dart';

class BrickBlock extends SpriteComponent with HasGameRef<MarioGame> {
  BrickBlock({super.position}) : super(size: Vector2.all(16));

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('mario/tile_set.png'),
      srcSize: Vector2.all(16),
      srcPosition: Vector2(16, 0),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  /// Action after Mario has bumped the box from below
  void bump() {
    add(MoveByEffect(
      Vector2(0, -8),
      EffectController(
        duration: 0.1,
        curve: Curves.fastEaseInToSlowEaseOut,
        reverseDuration: 0.1,
        reverseCurve: Curves.fastOutSlowIn,
      ),
    ));
  }
}
