import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_event.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/constants/hit_edge.dart';
import 'package:flutter_game/mario/constants/mario_vectors.dart';
import 'package:flutter_game/mario/constants/object_values.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/brick_block.dart';
import 'package:flutter_game/mario/objects/enemy_goomba.dart';
import 'package:flutter_game/mario/objects/ground_block.dart';
import 'package:flutter_game/mario/objects/powerup_fireball.dart';
import 'package:flutter_game/mario/objects/powerup_flower.dart';
import 'package:flutter_game/mario/objects/powerup_mushroom.dart';
import 'package:flutter_game/mario/objects/question_block.dart';
import 'package:flutter_game/mario/util/collision_util.dart';
import 'package:flutter_game/mario/widgets/FlipSprite.dart';

class MarioPlayer extends SpriteAnimationComponent
    with
        HasGameRef<MarioGame>,
        KeyboardHandler,
        CollisionCallbacks,
        FlameBlocListenable<StatsBloc, StatsState> {
  MarioPlayer({super.position}) : super(anchor: Anchor.bottomLeft);

  late Image image;

  MarioStatus _status = MarioStatus.stand;

  MarioSize _size = MarioSize.small;

  bool get isSmall => _size == MarioSize.small;

  bool isFlip = false;

  int horizontalDirection = 0;

  int verticalDirection = 0;

  double moveSpeed = 0;

  double jumpSpeed = 0;

  PositionComponent? _currentPlatform;

  double twinkleTime = 0;

  bool get invisibility => twinkleTime != 0;

  bool authorizedFire = false;

  bool get suspend =>
      bloc.state.status != GameStatus.running ||
      _status == MarioStatus.smallToBig ||
      _status == MarioStatus.bigToSmall ||
      _status == MarioStatus.bigToFireFlower ||
      _status == MarioStatus.bigThrow;

  @override
  FutureOr<void> onLoad() {
    image = game.images.fromCache('mario/mario_bros.png');
    add(RectangleHitbox());
    _loadStatus(MarioStatus.stand);
  }

  void _loadStatus(MarioStatus status) {
    if (status == _status && animation != null) {
      return;
    }
    _status = status;
    switch (_status) {
      case MarioStatus.stand:
        animation = _getAnimation(_size == MarioSize.small
            ? MarioVectors.normalSmallVector
            : MarioVectors.normalBigVector);
        break;
      case MarioStatus.walk:
        animation = _getAnimation(_size == MarioSize.small
            ? MarioVectors.normalSmallWalkVector
            : MarioVectors.normalBigWalkVector);
        break;
      case MarioStatus.skid:
        animation = _getAnimation(_size == MarioSize.small
            ? MarioVectors.normalSmallSkidVector
            : MarioVectors.normalBigSkidVector);
        break;
      case MarioStatus.jump:
        animation = _getAnimation(_size == MarioSize.small
            ? MarioVectors.normalSmallJumpVector
            : MarioVectors.normalBigJumpVector);
        break;
      case MarioStatus.smallToBig:
        animation = _getAnimation(MarioVectors.smallToBigVector,
            loop: false, stepTime: 0.07);
        break;
      case MarioStatus.bigToSmall:
        animation = _getAnimation(MarioVectors.bigToSmallVector,
            loop: false, stepTime: 0.07);
        twinkleTime = 0.01;
        break;
      case MarioStatus.bigToFireFlower:
        animation = _getAnimation(MarioVectors.bigToFireFlowerVector,
            loop: false, stepTime: 0.07);
        break;
      case MarioStatus.bigThrow:
        animation = _getAnimation(MarioVectors.bigThrowVector,
            loop: false, stepTime: 0.09);
        break;
      case MarioStatus.die:
        animation = _getAnimation(MarioVectors.dieVector);
        bloc.add(const GameOver());
        add(SequenceEffect(
          [
            MoveByEffect(
              Vector2(0, -48),
              EffectController(
                duration: 0.3,
                curve: Curves.fastEaseInToSlowEaseOut,
                startDelay: 0.8,
              ),
            ),
            MoveByEffect(
              Vector2(0, 88),
              EffectController(
                duration: 0.55,
                curve: Curves.easeInCubic,
              ),
            ),
            RemoveEffect(),
          ],
        ));
        break;
      default:
        break;
    }

    if (_status == MarioStatus.smallToBig) {
      animationTicker?.onComplete = () {
        _loadSize(MarioSize.big);
        _loadStatus(MarioStatus.stand);
      };
      return;
    } else if (_status == MarioStatus.bigToSmall) {
      animationTicker?.onComplete = () {
        _loadSize(MarioSize.small);
        _loadStatus(MarioStatus.stand);
      };
      return;
    } else if (_status == MarioStatus.bigToFireFlower) {
      animationTicker?.onComplete = () {
        _loadStatus(MarioStatus.stand);
        authorizedFire = true;
      };
      return;
    } else if (_status == MarioStatus.bigThrow) {
      animationTicker?.onComplete = () {
        _loadStatus(MarioStatus.stand);
        authorizedFire = true;
      };
      return;
    }
  }

  void _loadSize(MarioSize size) {
    if (size == _size) {
      return;
    }
    _size = size;
  }

  SpriteAnimation _getAnimation(
    List<List<double>> list, {
    bool loop = true,
    double stepTime = 0.1,
  }) {
    return SpriteAnimation.spriteList(
      list
          .map((e) => FlipSprite(
                image,
                isFlip,
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: stepTime,
      loop: loop,
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      isFlip = true;
      horizontalDirection = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      isFlip = false;
      horizontalDirection = 1;
    } else {
      horizontalDirection = 0;
    }
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      if (verticalDirection != 1) {
        verticalDirection = 1;
        if (jumpSpeed == 0) {
          jumpSpeed = -ObjectValues.marioJumpSpeedMax;
        }
      }
    } else {
      verticalDirection = 0;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyM)) {
      _shootFireball();
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (suspend) {
      return;
    }
    if (invisibility) {
      twinkleTime += dt;
      opacity = (opacity - 1).abs();
      if (twinkleTime > 1.5) {
        twinkleTime = 0;
        opacity = 1;
      }
    }

    // Change mario position.y
    if (jumpSpeed != 0) {
      _loadStatus(MarioStatus.jump);
      if (verticalDirection == 1 && jumpSpeed > -170 && jumpSpeed < 0) {
        // Long space key event, mario jump higher
        jumpSpeed += ObjectValues.marioGravityAccel *
            dt *
            ObjectValues.marioJumpHigherFactor;
      } else {
        jumpSpeed += ObjectValues.marioGravityAccel * dt;
      }
      y += jumpSpeed * dt;
    }
    if (jumpSpeed == 0) {
      if (horizontalDirection != 0 || moveSpeed != 0) {
        _loadStatus(MarioStatus.walk);
      } else {
        _loadStatus(MarioStatus.stand);
      }
    }
    // Change mario position.x
    if (horizontalDirection > 0) {
      if (moveSpeed < 0) {
        _loadStatus(MarioStatus.skid);
      }
      if (moveSpeed < ObjectValues.marioMoveSpeedMax) {
        moveSpeed += ObjectValues.marioMoveAccel;
      } else {
        moveSpeed = ObjectValues.marioMoveSpeedMax;
      }
    } else if (horizontalDirection < 0) {
      if (moveSpeed > 0) {
        _loadStatus(MarioStatus.skid);
      }
      if (moveSpeed > -ObjectValues.marioMoveSpeedMax) {
        moveSpeed -= ObjectValues.marioMoveAccel;
      } else {
        moveSpeed = -ObjectValues.marioMoveSpeedMax;
      }
    } else {
      if (moveSpeed.abs() > 0 &&
          moveSpeed.abs() < ObjectValues.marioMoveAccel) {
        moveSpeed = 0;
      }
      if (moveSpeed > 0) {
        moveSpeed -= ObjectValues.marioMoveAccel;
      } else if (moveSpeed < 0) {
        moveSpeed += ObjectValues.marioMoveAccel;
      }
    }
    if (x + moveSpeed * dt <= game.cameraComponent.viewfinder.position.x) {
      // Prevent Mario from going backwards at screen edge.
      x = game.cameraComponent.viewfinder.position.x;
      return;
    }
    double screenWidth = game.size.x / game.scaleSize;
    if (x + width >=
            game.cameraComponent.viewfinder.position.x + screenWidth / 2 &&
        game.mapComponent.width >
            game.cameraComponent.viewfinder.position.x + screenWidth) {
      // Viewfinder moves to the right
      game.cameraComponent.viewfinder.position = Vector2(
        min(x + width - screenWidth / 2, game.mapComponent.width - screenWidth),
        0,
      );
    }
    x += moveSpeed * dt;

    //Check mario is at the top of currentPlatform
    if (_currentPlatform != null) {
      if (x <= _currentPlatform!.x - width ||
          x >= _currentPlatform!.x + _currentPlatform!.width) {
        if (jumpSpeed == 0) {
          jumpSpeed = 1;
        }
        _currentPlatform = null;
      }
      if (_currentPlatform is EnemyGoomba && _currentPlatform!.height == 7) {
        // Goomba's height shortened after being squished by Mario
        jumpSpeed = -ObjectValues.marioReboundSpeed;
        _currentPlatform = null;
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (bloc.state.status != GameStatus.running) {
      return;
    }
    // TODO: When Mario hits multiple hitBoxes, handle component has more collision, ignore others.
    if (intersectionPoints.length < 2) {
      return;
    }
    if (other is PowerupMushroom) {
      _loadStatus(MarioStatus.smallToBig);
      return;
    } else if (other is PowerupFlower) {
      _loadStatus(MarioStatus.bigToFireFlower);
      return;
    } else if (other is BrickBlock && other.opacity == 0) {
      return;
    }
    HitEdge hitEdge = CollisionUtil.getHitEdge(intersectionPoints, other);
    // debugPrint('hitEdge=$hitEdge');
    if (hitEdge == HitEdge.top) {
      y = other.y;
      _currentPlatform = other;
      if (jumpSpeed != 0) {
        jumpSpeed = 0;
      }
    } else if (hitEdge == HitEdge.right) {
      if (invisibility && other is EnemyGoomba) {
        // invisibility, Goomba Mario doesn't affect each other
      } else {
        moveSpeed = 0;
        x = other.x + other.width;
      }
    } else if (hitEdge == HitEdge.bottom) {
      if (jumpSpeed < 0) {
        jumpSpeed = -jumpSpeed;
      }
    } else if (hitEdge == HitEdge.left) {
      if (invisibility && other is EnemyGoomba) {
        // invisibility, Goomba Mario doesn't affect each other
      } else {
        moveSpeed = 0;
        x = other.x - width;
      }
    }
    if (other is GroundBlock) {
      if (hitEdge == HitEdge.top) {
        if (jumpSpeed != 0) {
          jumpSpeed = 0;
        }
      }
    }
    if (other is BrickBlock) {
      if (hitEdge == HitEdge.bottom) {
        other.bump(_size);
      }
    } else if (other is QuestionBlock) {
      if (hitEdge == HitEdge.bottom) {
        other.bump(_size);
      }
    } else if (other is EnemyGoomba) {
      if (hitEdge == HitEdge.top) {
        other.squishes();
        other.killed = true;
      } else {
        if (invisibility || other.death) {
          // Mario ignores the enemy
        } else {
          _loadStatus(_size == MarioSize.small
              ? MarioStatus.die
              : MarioStatus.bigToSmall);
          if (_size == MarioSize.small) {
            other.killed = true;
          }
        }
      }
    }
  }

  int _lastFireballTime = 0;

  _shootFireball() {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _lastFireballTime <= 200) {
      return;
    }
    _loadStatus(MarioStatus.bigThrow);
    _lastFireballTime = currentTime;
    game.world.add(PowerupFireball(
      isFlip ? -1 : 1,
      position: Vector2(isFlip ? x - 8 : x + width, y - 24),
    ));
  }
}

enum MarioStatus {
  stand,
  walk,
  skid,
  jump,
  smallToBig,
  bigToSmall,
  bigToFireFlower,
  bigToFire,
  bigThrow,
  die,
}

enum MarioSize {
  small,
  big,
}
