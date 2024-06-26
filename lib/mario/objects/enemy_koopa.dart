import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_event.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/constants/hit_edge.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/coin_score.dart';
import 'package:flutter_game/mario/objects/ground_block.dart';
import 'package:flutter_game/mario/objects/powerup_fireball.dart';
import 'package:flutter_game/mario/util/collision_util.dart';

class EnemyKoopa extends SpriteAnimationComponent
    with
        HasGameRef<MarioGame>,
        CollisionCallbacks,
        FlameBlocReader<StatsBloc, StatsState> {
  EnemyKoopa({super.position, super.anchor = Anchor.bottomLeft});

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
        y - height > game.mapComponent.height) {
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
    FlameAudio.play('mario/kick.ogg');
    bloc.add(const ScoreEnemy());
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
    if (_death) {
      return;
    }
    if (other is PowerupFireball && horizontalDirection != 0 && !other.fired) {
      handleDeath(other);
    } else if (other is GroundBlock) {
      HitEdge hitEdge = CollisionUtil.getHitEdge(intersectionPoints, other);
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
    if (_death) {
      return;
    }
    if (other is GroundBlock) {
      jumpSpeed = 1;
    }
  }

  bool _death = false;

  bool get death => _death;

  handleDeath(PositionComponent other) {
    _death = true;
    animation = _getAnimation(shellVector);
    FlameAudio.play('mario/kick.ogg');
    flipVerticallyAroundCenter();
    jumpSpeed = ObjectValues.enemyDeathJumpSpeed;
    horizontalDirection = x >= other.center.x ? 1 : -1;
    bloc.add(const ScoreEnemy());
  }
}
