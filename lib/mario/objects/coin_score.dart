import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_game/mario/constants/character_vector.dart';
import 'package:flutter_game/mario/mario_game.dart';

class CoinScore extends PositionComponent with HasGameRef<MarioGame> {
  CoinScore(this.number, {super.position});

  final String number;

  @override
  FutureOr<void> onLoad() {
    List<Component> list = [];
    Image image = game.images.fromCache('mario/text_images.png');
    for (int i = 0; i < number.length; i++) {
      Vector2 vector2 =
          CharacterVector.characterMap[number[i]] ?? Vector2(0, 0);
      list.add(SpriteComponent(
        sprite: Sprite(
          image,
          srcPosition: vector2,
          srcSize: Vector2(7, 7),
        ),
        position: Vector2(i * 8, 0),
      ));
    }
    add(PositionComponent(
      position: position,
      scale: scale * 0.7,
      children: list,
    ));
  }
}
