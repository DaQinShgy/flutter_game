import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/mario/mario_game.dart';

class CoinIcon extends SpriteAnimationComponent with HasGameRef<MarioGame> {
  CoinIcon(
    this.type, {
    super.position,
    super.anchor = Anchor.topCenter,
    super.priority = -1,
    super.scale,
  });

  final CoinType type;

  //Vector of twinkle coin
  List<List<double>> twinkleVector = [
    [387, 18, 10, 14],
    [403, 18, 10, 14],
    [419, 18, 10, 14],
  ];

  //Vector of spinning coin
  List<List<double>> spinningVector = [
    [52, 113, 8, 14],
    [4, 113, 8, 14],
    [20, 113, 8, 14],
    [36, 113, 8, 14],
  ];

  @override
  FutureOr<void> onLoad() {
    if (type == CoinType.twinkle) {
      animation = SpriteAnimation.variableSpriteList(
        twinkleVector
            .map((e) => Sprite(
                  game.images.fromCache('mario/tile_set.png'),
                  srcPosition: Vector2(e[0], e[1]),
                  srcSize: Vector2(e[2], e[3]),
                ))
            .toList(),
        stepTimes: [0.4, 0.2, 0.2],
      );
    } else {
      animation = SpriteAnimation.spriteList(
        spinningVector
            .map((e) => Sprite(
                  game.images.fromCache('mario/item_objects.png'),
                  srcPosition: Vector2(e[0], e[1]),
                  srcSize: Vector2(e[2], e[3]),
                ))
            .toList(),
        stepTime: 0.15,
      );
    }
  }
}

enum CoinType {
  twinkle,
  spinning,
}
