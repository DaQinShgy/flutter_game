import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/actors/mario_player.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/constants/hit_edge.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';
import 'package:flutter_game/mario/objects/ground_block.dart';
import 'package:flutter_game/mario/util/collision_util.dart';

class BrickStar extends SpriteAnimationComponent
    with
        HasGameRef<MarioGame>,
        CollisionCallbacks,
        FlameBlocReader<StatsBloc, StatsState> {
  BrickStar() : super(position: Vector2(1, 0), priority: -1);

  List<List<double>> vector = [
    [1, 48, 15, 16],
    [17, 48, 15, 16],
    [33, 48, 15, 16],
    [49, 48, 15, 16],
  ];

  @override
  Future<void> onLoad() {
    animation = SpriteAnimation.spriteList(
      vector
          .map((e) => Sprite(
                game.images.fromCache('mario/item_objects.png'),
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: 0.1,
    );

    add(RectangleHitbox());

    add(MoveByEffect(
      Vector2(0, -16),
      LinearEffectController(0.6),
      onComplete: () {
        horizontalDirection = 1;
        jumpSpeed = -20;
      },
    ));
    return super.onLoad();
  }

  int horizontalDirection = 0;

  double jumpSpeed = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.status != GameStatus.running) {
      playing = false;
      return;
    }
    if (horizontalDirection == 0) {
      return;
    }
    x += ObjectValues.starMoveSpeed * horizontalDirection * dt;
    jumpSpeed += ObjectValues.starGravityAccel * dt;
    y += jumpSpeed * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is GroundBlock) {
      HitEdge hitEdge = CollisionUtil.getHitEdge(intersectionPoints, other);
      if (hitEdge == HitEdge.top) {
        jumpSpeed = -240;
      } else {
        horizontalDirection = -horizontalDirection;
      }
    } else if (other is ColliderBlock) {
      horizontalDirection = -horizontalDirection;
    } else if (other is MarioPlayer) {
      removeFromParent();
    }
  }
}
