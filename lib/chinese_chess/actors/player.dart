import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_game/chinese_chess/chess_game.dart';

class Player extends PositionComponent with HasGameRef<ChessGame> {
  Player(
    this._type, {
    super.size,
    super.position,
    super.anchor,
  });

  final PlayerType _type;

  final List<List<double>> _personVector = [
    [2, 2, 102, 102],
    [2, 108, 96, 96],
    [2, 208, 96, 96],
    [2, 308, 96, 96],
    [2, 408, 96, 96],
    [2, 508, 96, 96],
    [2, 608, 96, 96],
    [108, 2, 96, 96],
    [108, 102, 96, 96],
    [102, 202, 96, 96],
    [102, 302, 96, 96],
    [102, 402, 96, 96],
    [102, 502, 96, 96],
    [102, 602, 96, 96],
  ];

  @override
  FutureOr<void> onLoad() {
    SpriteComponent frameSprite = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('chinese_chess/objects1.png'),
        srcSize: Vector2(68, 68),
        srcPosition:
            _type == PlayerType.red ? Vector2(642, 218) : Vector2(642, 362),
      ),
      size: Vector2(size.x, size.x),
    );
    List<double> randomVector =
        _personVector[Random().nextInt(_personVector.length)];
    SpriteComponent characterSprite = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('chinese_chess/character.png'),
        srcPosition: Vector2(randomVector[0], randomVector[1]),
        srcSize: Vector2(randomVector[2], randomVector[3]),
      ),
      position: Vector2(size.x * 0.1, size.x * 0.1),
      size: Vector2(size.x * 0.8, size.x * 0.8),
    );
    addAll([frameSprite, characterSprite]);
  }
}

enum PlayerType { red, black }
