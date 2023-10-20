import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/mario/mario_game.dart';

class BrickBlock extends SpriteComponent with HasGameRef<MarioGame> {
  BrickBlock({super.position}) : super(size: Vector2.all(16));

  @override
  FutureOr<void> onLoad() {
    scale = scale * game.unitSize;
    sprite = Sprite(
      game.images.fromCache('mario/tile_set.png'),
      srcSize: Vector2.all(16),
      srcPosition: Vector2(16, 0),
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
