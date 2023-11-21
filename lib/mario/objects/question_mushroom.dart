import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/coin_score.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';
import 'package:flutter_game/mario/objects/hole.dart';
import 'package:flutter_game/mario/objects/question_block.dart';

class QuestionMushroom extends SpriteComponent
    with HasGameRef<MarioGame>, CollisionCallbacks {
  QuestionMushroom(this.type, this.id, {super.position, super.priority = -1});

  final MushroomType type;

  final int id;

  // Vector of red mushroom
  List<double> redMushroomVector = [0, 0, 16, 16];

  // Vector of green mushroom
  List<double> greenMushroomVector = [16, 0, 16, 16];

  late RectangleHitbox _hitbox;

  double platformWidth = 0;

  @override
  FutureOr<void> onLoad() {
    List<double> mushroomVector =
        type == MushroomType.red ? redMushroomVector : greenMushroomVector;
    sprite = Sprite(
      game.images.fromCache('mario/item_objects.png'),
      srcPosition: Vector2(mushroomVector[0], mushroomVector[1]),
      srcSize: Vector2(mushroomVector[2], mushroomVector[3]),
    );
    _hitbox = RectangleHitbox();
    add(_hitbox);

    add(MoveByEffect(
      Vector2(0, -16),
      LinearEffectController(0.6),
      onComplete: () {
        horizontalDirection = 1;
      },
    ));

    if (id == 3) {
      platformWidth = 64;
    } else if (id == 16) {
      platformWidth = 16;
    }
  }

  int horizontalDirection = 0;

  double jumpSpeed = 0;

  double groundY = ObjectValues.groundY;

  bool get isOnGround => y >= groundY - (parent as QuestionBlock).y - height;

  @override
  void update(double dt) {
    super.update(dt);
    if (opacity == 0) {
      return;
    }
    x += ObjectValues.mushroomMoveSpeed * horizontalDirection * dt;
    if (x >= platformWidth && !isOnGround) {
      jumpSpeed += ObjectValues.enemyGravityAccel * dt;
      y += jumpSpeed * dt;
    }
    debugPrint('y=$y');
    if (isOnGround) {
      y = groundY - (parent as QuestionBlock).y - height;
    }
    double screenWidth = game.size.x / game.scaleSize;
    if ((parent as PositionComponent).x + x + width <
            game.cameraComponent.viewfinder.position.x ||
        (parent as PositionComponent).x + x >
            game.cameraComponent.viewfinder.position.x + screenWidth) {
      // Mushroom moves off screen edge
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ColliderBlock) {
      horizontalDirection = -1;
    } else if (other is MarioPlayer) {
      remove(_hitbox);
      opacity = 0;
      CoinScore coinScore = CoinScore(
        '1000',
        position: Vector2(width / 2, -10),
      );
      add(coinScore);
      coinScore.add(MoveByEffect(
        Vector2(0, -40),
        EffectController(
          duration: 0.5,
        ),
        onComplete: () {
          remove(coinScore);
          removeFromParent();
        },
      ));
    } else if (other is Hole) {
      if ((parent as QuestionBlock).x + x >= other.x &&
          (parent as QuestionBlock).x + x + width <= other.x + other.width &&
          groundY == ObjectValues.groundY) {
        jumpSpeed == 0;
        groundY += 56;
      }
    }
  }
}

enum MushroomType { red, green }
