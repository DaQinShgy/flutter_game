import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/tetris/tetris_game.dart';

class IconTrumpet extends SpriteComponent with HasGameRef<TetrisGame> {
  IconTrumpet({super.position}) : super(size: Vector2(18, 14));

  late Sprite spriteValid;

  late Sprite spriteInvalid;

  @override
  FutureOr<void> onLoad() {
    spriteValid = Sprite(
      game.images.fromCache('tetris.png'),
      srcPosition: Vector2(150, 75),
      srcSize: Vector2(25, 21),
    );
    spriteInvalid = Sprite(
      game.images.fromCache('tetris.png'),
      srcPosition: Vector2(175, 75),
      srcSize: Vector2(25, 21),
    );
    sprite = spriteValid;
  }
}
