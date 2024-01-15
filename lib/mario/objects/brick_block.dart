import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/brick_star.dart';
import 'package:flutter_game/mario/objects/coin_icon.dart';
import 'package:flutter_game/mario/objects/coin_score.dart';

class BrickBlock extends PositionComponent with HasGameRef<MarioGame> {
  BrickBlock(this.type, {super.position}) : super(size: Vector2.all(16));

  String type;

  int coinCount = 0;

  late SpriteComponent componentBrick;

  @override
  FutureOr<void> onLoad() {
    if (type == 'coin') {
      coinCount = 6;
    }
    componentBrick = SpriteComponent(
        sprite: Sprite(
      game.images.fromCache('mario/tile_set.png'),
      srcSize: Vector2.all(16),
      srcPosition: Vector2(16, 0),
    ));
    add(componentBrick);
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  bool _bumped = false;

  bool get bumped => _bumped;

  /// Action after Mario has bumped the box from below
  void bump(MarioSize size) {
    if (type == 'coin') {
      if (coinCount == 1) {
        remove(componentBrick);
        componentBrick = SpriteComponent(
            sprite: Sprite(
          game.images.fromCache('mario/tile_set.png'),
          srcSize: Vector2.all(16),
          srcPosition: Vector2(432, 0),
        ));
        add(componentBrick);
      }
      if (coinCount <= 0) {
        return;
      }
    } else if (type == 'star') {
      remove(componentBrick);
      componentBrick = SpriteComponent(
          sprite: Sprite(
        game.images.fromCache('mario/tile_set.png'),
        srcSize: Vector2.all(16),
        srcPosition: Vector2(432, 0),
      ));
      add(componentBrick);
      add(MoveByEffect(
        Vector2(0, -8),
        EffectController(
          duration: 0.1,
          curve: Curves.fastEaseInToSlowEaseOut,
          reverseDuration: 0.1,
          reverseCurve: Curves.fastOutSlowIn,
        ),
      ));
      add(BrickStar());
      return;
    }
    if (size == MarioSize.small || coinCount > 0) {
      _bumped = true;
      add(MoveByEffect(
        Vector2(0, -8),
        EffectController(
          duration: 0.1,
          curve: Curves.fastEaseInToSlowEaseOut,
          reverseDuration: 0.1,
          reverseCurve: Curves.fastOutSlowIn,
        ),
        onComplete: () {
          _bumped = false;
        },
      ));
      if (coinCount-- > 0) {
        _handleCoin();
      }
    } else {
      componentBrick.opacity = 0;
      _buildBrickPiece(0, 0, 0);
      _buildBrickPiece(width, 0, 1);
      _buildBrickPiece(0, height, 2);
      _buildBrickPiece(width, height, 3);
    }
  }

  void _buildBrickPiece(double x, double y, int index) {
    SpriteComponent brickPiece = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('mario/item_objects.png'),
        srcPosition: Vector2(68, 20),
        srcSize: Vector2(8, 8),
      ),
      position: Vector2(x, y),
    );
    if (index == 1) {
      brickPiece.flipHorizontally();
    } else if (index == 2) {
      brickPiece.flipVertically();
    } else if (index == 3) {
      brickPiece.flipVertically();
      brickPiece.flipHorizontally();
    }
    add(brickPiece);
    Path path = Path();
    if (index == 0) {
      path.conicTo(-16, -64, -48, 88, 3);
    } else if (index == 1) {
      path.conicTo(width + 16, -64, width + 48, 88, 3);
    } else if (index == 2) {
      path.conicTo(-16, -16, -48, 88, 3);
    } else if (index == 3) {
      path.conicTo(width + 16, -16, width + 48, 88, 3);
    }
    brickPiece.add(MoveAlongPathEffect(
      path,
      EffectController(duration: 0.5),
      onComplete: () {
        brickPiece.removeFromParent();
        removeFromParent();
      },
    ));
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
}
