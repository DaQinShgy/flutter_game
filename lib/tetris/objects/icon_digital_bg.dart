import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/teris_game.dart';

class IconDigitalBg extends PositionComponent with HasGameRef<TerisGame> {
  IconDigitalBg({super.position}) : super(size: Vector2(60, 17));

  @override
  FutureOr<void> onLoad() {
    SpriteBatch spriteBatch = SpriteBatch(game.images.fromCache('tetris.png'));
    for (var i = 0; i < 6; ++i) {
      spriteBatch.add(
        source: const Rect.fromLTWH(215, 25, 14, 23.8),
        offset: Vector2(i * 10, 0),
        scale: 10 / 14,
      );
    }
    add(SpriteBatchComponent(spriteBatch: spriteBatch));
  }
}
