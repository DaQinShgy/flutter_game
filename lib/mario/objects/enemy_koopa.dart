import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/constants/hit_edge.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/coin_score.dart';
import 'package:flutter_game/mario/objects/ground_block.dart';
import 'package:flutter_game/mario/util/collision_util.dart';

class EnemyKoopa extends SpriteAnimationComponent
    with
        HasGameRef<MarioGame>,
        CollisionCallbacks,
        FlameBlocReader<StatsBloc, StatsState> {
  EnemyKoopa({super.position, super.anchor = Anchor.bottomLeft});

  @override
  bool get debugMode => true;

  List<List<double>> walkVector = [
    [150, 0, 16, 24],
    [180, 0, 16, 24],
  ];

  List<List<double>> shellVector = [
    [360, 5, 16, 15],
  ];

  @override
  Future<void> onLoad() {
    animation = _getAnimation(walkVector);
    add(RectangleHitbox());
    return super.onLoad();
  }

  SpriteAnimation _getAnimation(List<List<double>> list) {
    return SpriteAnimation.spriteList(
      list
          .map((e) => Sprite(
                game.images.fromCache('mario/smb_enemies_sheet.png'),
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: 0.2,
    );
  }

  int horizontalDirection = 0;

  double moveSpeed = 0;

  double jumpSpeed = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.status != GameStatus.running) {
      playing = false;
      return;
    }
    double screenWidth = game.size.x / game.scaleSize;
    if (game.cameraComponent.viewfinder.position.x + screenWidth >= x &&
        horizontalDirection == 0) {
      horizontalDirection = -1;
      moveSpeed = ObjectValues.enemyMoveSpeed;
    }
    x += moveSpeed * horizontalDirection * dt;
    if (x + width < game.cameraComponent.viewfinder.position.x ||
        y > game.mapComponent.height) {
      removeFromParent();
    }
    if (jumpSpeed != 0) {
      jumpSpeed += ObjectValues.enemyGravityAccel * dt;
      y += jumpSpeed * dt;
    }
  }

  bool _shelled = false;

  bool get shelled => _shelled;

  void squishes() {
    animation = _getAnimation(shellVector);
    _shelled = true;
    moveSpeed = 0;
    CoinScore coinScore = CoinScore(
      '100',
      position: Vector2(width / 2, -10),
    );
    add(coinScore);
    coinScore.add(MoveByEffect(
      Vector2(0, -24),
      EffectController(
        duration: 0.4,
      ),
      onComplete: () {
        remove(coinScore);
      },
    ));
  }

  sliding(horizontalDirection) {
    this.horizontalDirection = horizontalDirection;
    moveSpeed = ObjectValues.enemyMoveSpeed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    HitEdge hitEdge = CollisionUtil.getHitEdge(intersectionPoints, other);
    if (other is GroundBlock) {
      if (hitEdge == HitEdge.top) {
        y = other.y + 1;
        jumpSpeed = 0;
      } else if (hitEdge == HitEdge.right) {
        x = other.x + other.width;
      } else if (hitEdge == HitEdge.left) {
        x = other.x - width;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is GroundBlock) {
      jumpSpeed = 1;
    }
  }
}
