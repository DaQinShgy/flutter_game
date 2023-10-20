import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game/mario/mario_game.dart';

class CoinIcon extends SpriteAnimationComponent with HasGameRef<MarioGame> {
  CoinIcon({super.position}) : super(size: Vector2(10, 14));

  late Image image;

  //Vector of twinkle coin
  List<Vector2> twinkleVector = [
    Vector2(387, 18),
    Vector2(403, 18),
    Vector2(419, 18),
  ];

  @override
  FutureOr<void> onLoad() {
    scale = scale / game.unitSize;
    image = game.images.fromCache('mario/tile_set.png');
    animation = SpriteAnimation.variableSpriteList(
      twinkleVector
          .map((e) => Sprite(image, srcPosition: e, srcSize: Vector2(10, 14)))
          .toList(),
      stepTimes: [0.4, 0.2, 0.2],
    );
  }
}
