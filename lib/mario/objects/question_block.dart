import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/mario/mario_game.dart';

class QuestionBlock extends SpriteAnimationComponent
    with HasGameRef<MarioGame> {
  QuestionBlock({super.position}) : super(size: Vector2.all(16));

  late Image image;

  //Default twinkle status
  List<List<Vector2>> twinkleVector = [
    [Vector2(384, 0), Vector2(16, 16)],
    [Vector2(400, 0), Vector2(16, 16)],
    [Vector2(416, 0), Vector2(16, 16)],
  ];

  @override
  FutureOr<void> onLoad() {
    image = game.images.fromCache('mario/tile_set.png');
    animation = SpriteAnimation.variableSpriteList(
      twinkleVector
          .map((e) => Sprite(image, srcPosition: e[0], srcSize: e[1]))
          .toList(),
      stepTimes: [0.4, 0.2, 0.2],
    );
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
