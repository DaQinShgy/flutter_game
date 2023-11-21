import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/coin_icon.dart';
import 'package:flutter_game/mario/objects/coin_score.dart';
import 'package:flutter_game/mario/objects/question_mushroom.dart';

class QuestionBlock extends PositionComponent with HasGameRef<MarioGame> {
  QuestionBlock(this.type, this.id, {super.position})
      : super(size: Vector2.all(16));

  late QuestionType type;

  final int id;

  late Image image;

  late Component component;

  //Default twinkle status
  List<List<double>> twinkleVector = [
    [384, 0, 16, 16],
    [400, 0, 16, 16],
    [416, 0, 16, 16],
  ];

  //Bumped status
  List<double> bumpedVector = [432, 0, 16, 16];

  @override
  FutureOr<void> onLoad() {
    image = game.images.fromCache('mario/tile_set.png');
    component = SpriteAnimationComponent(
      animation: SpriteAnimation.variableSpriteList(
        twinkleVector
            .map((e) => Sprite(
                  image,
                  srcPosition: Vector2(e[0], e[1]),
                  srcSize: Vector2(e[2], e[3]),
                ))
            .toList(),
        stepTimes: [0.4, 0.2, 0.2],
      ),
    );
    add(component);
    add(RectangleHitbox(collisionType: CollisionType.passive));

    if (type == QuestionType.greenMushroom) {
      (component as SpriteAnimationComponent).opacity = 0;
    }
  }

  /// Action after Mario has bumped the box from below
  void bump() {
    if (component is SpriteComponent) {
      return;
    }
    // Update questionBlock state
    remove(component);
    component = SpriteComponent(
      sprite: Sprite(
        image,
        srcPosition: Vector2(bumpedVector[0], bumpedVector[1]),
        srcSize: Vector2(bumpedVector[2], bumpedVector[3]),
      ),
    );
    add(component);

    add(MoveByEffect(
      Vector2(0, -8),
      EffectController(
        duration: 0.1,
        curve: Curves.fastEaseInToSlowEaseOut,
        reverseDuration: 0.1,
        reverseCurve: Curves.fastOutSlowIn,
      ),
    ));

    switch (type) {
      case QuestionType.coin:
        _handleCoin();
        break;
      case QuestionType.redMushroom:
        _handleMushroom(MushroomType.red);
        break;
      case QuestionType.greenMushroom:
        _handleMushroom(MushroomType.green);
        break;
    }
  }

  void _handleCoin() {
    CoinIcon coinIcon =
        CoinIcon(CoinType.spinning, position: Vector2(width / 2, 0));
    add(coinIcon);
    coinIcon.add(SequenceEffect([
      MoveByEffect(
        Vector2(0, -56),
        EffectController(
          duration: 0.42,
          curve: Curves.fastEaseInToSlowEaseOut,
        ),
      ),
      MoveByEffect(
        Vector2(0, 32),
        EffectController(
          duration: 0.24,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      RemoveEffect(),
    ], onComplete: () {
      CoinScore coinScore = CoinScore(
        '200',
        position: Vector2(width / 2, -16),
      );
      add(coinScore);
      coinScore.add(MoveByEffect(
        Vector2(0, -32),
        EffectController(
          duration: 0.3,
          curve: Curves.fastEaseInToSlowEaseOut,
        ),
        onComplete: () {
          remove(coinScore);
        },
      ));
    }));
  }

  void _handleMushroom(MushroomType type) {
    add(QuestionMushroom(type, id));
  }
}

enum QuestionType {
  coin,
  redMushroom,
  greenMushroom,
}
