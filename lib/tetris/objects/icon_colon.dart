import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/tetris/tetris_game.dart';

class IconColon extends SpriteComponent with HasGameRef<TetrisGame> {
  IconColon({super.position}) : super(size: Vector2(10, 17));

  late Sprite spriteValid;

  late Sprite spriteInvalid;

  late final Timer timer;

  @override
  FutureOr<void> onLoad() {
    spriteValid = Sprite(
      game.images.fromCache('tetris/tetris.png'),
      srcPosition: Vector2(229, 25),
      srcSize: Vector2(14, 24),
    );
    spriteInvalid = Sprite(
      game.images.fromCache('tetris/tetris.png'),
      srcPosition: Vector2(243, 25),
      srcSize: Vector2(14, 24),
    );
    sprite = spriteValid;

    timer = Timer(1, repeat: true, onTick: () {
      sprite = sprite == spriteValid ? spriteInvalid : spriteValid;
    }, autoStart: true);
  }

  @override
  void update(double dt) {
    timer.update(dt);
  }
}
