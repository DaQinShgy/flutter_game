import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_event.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/constants/hit_edge.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/brick_block.dart';
import 'package:flutter_game/mario/objects/coin_score.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';
import 'package:flutter_game/mario/objects/ground_block.dart';
import 'package:flutter_game/mario/objects/question_block.dart';
import 'package:flutter_game/mario/util/collision_util.dart';

class PowerupMushroom extends SpriteComponent
    with
        HasGameRef<MarioGame>,
        CollisionCallbacks,
        FlameBlocReader<StatsBloc, StatsState> {
  PowerupMushroom(this.type, this.id, {super.position, super.priority = -1});

  final MushroomType type;

  final int id;

  // Vector of red mushroom
  List<double> redMushroomVector = [0, 0, 16, 16];

  // Vector of green mushroom
  List<double> greenMushroomVector = [16, 0, 16, 16];

  late RectangleHitbox _hitbox;

  @override
  Future<void> onLoad() {
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
      Vector2(0, -height),
      LinearEffectController(0.6),
      onComplete: () {
        horizontalDirection = 1;
        jumpSpeed = 1;
      },
    ));
    return super.onLoad();
  }

  int horizontalDirection = 0;

  double jumpSpeed = 0;

  PositionComponent? _currentPlatform;

  @override
  void update(double dt) {
    super.update(dt);
    if (opacity == 0) {
      return;
    }
    x += ObjectValues.mushroomMoveSpeed * horizontalDirection * dt;

    if (horizontalDirection != 0) {
      if (jumpSpeed != 0) {
        jumpSpeed += ObjectValues.mushroomGravityAccel * dt;
        y += jumpSpeed * dt;
      }
    }
    double screenWidth = game.size.x / game.scaleSize;
    if ((parent as PositionComponent).x + x + width <
            game.cameraComponent.viewfinder.position.x ||
        (parent as PositionComponent).x + x >
            game.cameraComponent.viewfinder.position.x + screenWidth ||
        (parent as PositionComponent).y + y > game.mapComponent.height) {
      // Mushroom moves off screen edge
      removeFromParent();
    }

    if (_currentPlatform != null) {
      if (x + (parent as QuestionBlock).x <= _currentPlatform!.x - width ||
          x + (parent as QuestionBlock).x >=
              _currentPlatform!.x + _currentPlatform!.width) {
        if (jumpSpeed == 0) {
          jumpSpeed = 1;
        }
        _currentPlatform = null;
      }
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
      if (type == MushroomType.red) {
        bloc.add(const ScoreMushroom());
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
        FlameAudio.play('mario/powerup.ogg');
      } else {
        bloc.add(const ScoreMushroom());
        CoinScore coinScore = CoinScore(
          '1UP',
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
        FlameAudio.play('mario/one_up.ogg');
      }
    } else if (other is GroundBlock) {
      HitEdge hitEdge = CollisionUtil.getHitEdge(intersectionPoints, other);
      if (hitEdge == HitEdge.top) {
        y = other.y - (parent as QuestionBlock).y - height;
        _currentPlatform = other;
        if (jumpSpeed != 0) {
          jumpSpeed = 0;
        }
      } else if (hitEdge == HitEdge.right) {
        x = other.x + other.width - (parent as QuestionBlock).x;
      } else if (hitEdge == HitEdge.left) {
        x = other.x - (parent as QuestionBlock).x - width;
      }
    } else if ((other is QuestionBlock || other is BrickBlock) &&
        horizontalDirection != 0) {
      y = other.y - (parent as QuestionBlock).y - height;
      _currentPlatform = other;
      if (jumpSpeed != 0) {
        jumpSpeed = 0;
      }
    }
  }
}

enum MushroomType { red, green }
