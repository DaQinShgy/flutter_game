import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/teris_game.dart';

class IconNumber extends PositionComponent with HasGameRef<TerisGame> {
  IconNumber({required this.number, super.position});

  String number;

  @override
  FutureOr<void> onLoad() {
    SpriteBatch spriteBatch = SpriteBatch(game.images.fromCache('tetris.png'));
    for (var i = 0; i < number.length; ++i) {
      final dx = 75.0 + 14 * int.parse(number.substring(i, i + 1));
      spriteBatch.add(
        source: Rect.fromLTWH(dx, 25, 14, 23.8),
        offset: Vector2(i * 10, 0),
        scale: 10 / 14,
      );
    }
    add(SpriteBatchComponent(spriteBatch: spriteBatch));
  }
}
