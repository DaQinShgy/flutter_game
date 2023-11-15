import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_game/mario/mario_game.dart';

class CoinScore extends PositionComponent with HasGameRef<MarioGame> {
  CoinScore(this.number, {super.position});

  final String number;

  final Map<int, List<double>> mapDigital = {
    0: [0.5, 168, 4, 8],
    1: [5, 168, 3, 8],
    2: [7.5, 168, 4, 8],
    4: [12, 168, 4, 8],
    5: [16, 168, 5, 8],
    8: [20, 168, 4, 8],
    3: [32, 168, 5, 8],
    7: [37, 168, 6, 8],
    9: [43, 168, 5, 8],
  };

  @override
  FutureOr<void> onLoad() {
    scale = scale * 0.7;
    SpriteBatch spriteBatch =
        SpriteBatch(game.images.fromCache('mario/item_objects.png'));
    double offsetX = 0;
    for (var i = 0; i < number.length; ++i) {
      List<double> list = mapDigital[int.parse(number.substring(i, i + 1))]!;
      spriteBatch.add(
        source: Rect.fromLTWH(list[0], list[1], list[2], list[3]),
        offset: Vector2(offsetX, 0),
      );
      offsetX += list[2];
    }
    add(SpriteBatchComponent(spriteBatch: spriteBatch));
  }
}
