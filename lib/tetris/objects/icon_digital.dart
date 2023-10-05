import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/tetris/tetris_game.dart';

class IconDigital extends SpriteComponent with HasGameRef<TetrisGame> {
  IconDigital({
    required this.digital,
    super.position,
  }) : super(size: Vector2(10, 17));

  int digital;

  @override
  FutureOr<void> onLoad() async {
    assert(digital >= 0 && digital <= 9, 'The digital must be >=0 && <=9');
    updateDigital(digital);
  }

  updateDigital(int digital) {
    final dx = 75.0 + 14 * digital;
    sprite = Sprite(
      game.images.fromCache('tetris.png'),
      srcPosition: Vector2(dx, 25),
      srcSize: Vector2(14, 23.8),
    );
  }
}
