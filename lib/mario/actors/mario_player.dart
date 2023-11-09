import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/brick_block.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';
import 'package:flutter_game/mario/objects/question_block.dart';
import 'package:flutter_game/mario/widgets/FlipSprite.dart';

class MarioPlayer extends SpriteAnimationComponent
    with
        HasGameRef<MarioGame>,
        KeyboardHandler,
        CollisionCallbacks,
        FlameBlocListenable<StatsBloc, StatsState> {
  MarioPlayer({super.position}) : super(anchor: Anchor.bottomLeft);

  late Image image;

  MarioStatus _status = MarioStatus.initial;

  int horizontalDirection = 0;

  int verticalDirection = 0;

  double moveSpeed = 0;

  final double moveSpeedMax = 180;

  final double moveAccel = 10;

  double jumpSpeed = 0;

  final double gravityAccel = 800;

  double groundHeight = 0;

  bool get isOnGround => (y >= groundHeight);

  //Vector for normal small mario
  List<List<double>> normalSmallVector = [
    [178, 32, 12, 16],
  ];

  //Vector for normal small mario walking
  List<List<double>> normalSmallWalkingVector = [
    [80, 32, 15, 16],
    [96, 32, 16, 16],
    [112, 32, 16, 16],
  ];

  //Vector for normal small mario skid
  List<List<double>> normalSmallSkidVector = [
    [130, 32, 14, 16],
  ];

  //Vector for normal small mario jump
  List<List<double>> normalSmallJumpVector = [
    [144, 32, 16, 16],
  ];

  @override
  FutureOr<void> onLoad() {
    image = game.images.fromCache('mario/mario_bros.png');
    add(RectangleHitbox());
    _loadStatus(MarioStatus.normal);
    groundHeight = position.y;
  }

  void _loadStatus(MarioStatus status) {
    if (status == _status) {
      return;
    }
    _status = status;
    switch (_status) {
      case MarioStatus.normal:
        animation = _getAnimation(normalSmallVector);
        break;
      case MarioStatus.normalFlip:
        animation = _getAnimation(normalSmallVector, flip: true);
        break;
      case MarioStatus.forwardWalking:
        animation = _getAnimation(normalSmallWalkingVector);
        break;
      case MarioStatus.backwardWalking:
        animation = _getAnimation(normalSmallWalkingVector, flip: true);
        break;
      case MarioStatus.skid:
        animation = _getAnimation(normalSmallSkidVector);
        break;
      case MarioStatus.jump:
        animation = _getAnimation(normalSmallJumpVector);
        break;
      default:
        break;
    }
  }

  SpriteAnimation _getAnimation(List<List<double>> list, {bool flip = false}) {
    return SpriteAnimation.spriteList(
      list
          .map((e) => FlipSprite(
                image,
                flip,
                srcPosition: Vector2(e[0], e[1]),
                srcSize: Vector2(e[2], e[3]),
              ))
          .toList(),
      stepTime: 0.1,
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (bloc.state.status != GameStatus.running) {
      return true;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      horizontalDirection = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      horizontalDirection = 1;
    } else {
      horizontalDirection = 0;
    }
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      if (verticalDirection != 1) {
        verticalDirection = 1;
        if (isOnGround) {
          jumpSpeed = -270;
        }
      }
    } else {
      verticalDirection = 0;
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Change mario position.y
    if (jumpSpeed != 0) {
      _loadStatus(MarioStatus.jump);
      jumpSpeed += gravityAccel * dt;
      y += jumpSpeed * dt;
    }
    if (isOnGround) {
      y = groundHeight;
      jumpSpeed = 0;

      if (horizontalDirection > 0) {
        _loadStatus(MarioStatus.forwardWalking);
      } else if (horizontalDirection < 0) {
        _loadStatus(MarioStatus.backwardWalking);
      } else {
        if (_status == MarioStatus.backwardWalking ||
            _status == MarioStatus.normalFlip) {
          _loadStatus(MarioStatus.normalFlip);
        } else {
          _loadStatus(MarioStatus.normal);
        }
      }
    }
    // Change mario position.x
    if (horizontalDirection > 0) {
      if (moveSpeed < 0) {
        _loadStatus(MarioStatus.skid);
      }
      if (moveSpeed < moveSpeedMax) {
        moveSpeed += moveAccel;
      } else {
        moveSpeed = moveSpeedMax;
      }
    } else if (horizontalDirection < 0) {
      if (moveSpeed > 0) {
        _loadStatus(MarioStatus.skid);
      }
      if (moveSpeed > -moveSpeedMax) {
        moveSpeed -= moveAccel;
      } else {
        moveSpeed = -moveSpeedMax;
      }
    } else {
      if (moveSpeed.abs() > 0 && moveSpeed.abs() < moveAccel) {
        moveSpeed = 0;
      }
      if (moveSpeed > 0) {
        moveSpeed -= moveAccel;
      } else if (moveSpeed < 0) {
        moveSpeed += moveAccel;
      }
    }
    if (position.x + moveSpeed * dt <=
        game.cameraComponent.viewfinder.position.x) {
      // Prevent Mario from going backwards at screen edge.
      x = game.cameraComponent.viewfinder.position.x;
      return;
    }
    double halfScreenWidth = game.size.x / game.scaleSize / 2;
    if (position.x + size.x >=
            game.cameraComponent.viewfinder.position.x + halfScreenWidth &&
        horizontalDirection > 0) {
      // Viewfinder moves to the right
      game.cameraComponent.viewfinder.position =
          Vector2(position.x + size.x - halfScreenWidth, 0);
    }
    x += moveSpeed * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (intersectionPoints.length < 2) {
      return;
    }
    // debugPrint('intersectionPoints=$intersectionPoints');
    // 0 top; 1 right; 2 bottom; 3 left;
    int hitEdge = -1;
    List<double> listX = intersectionPoints.map((e) => e.x).toList();
    double diffX = listX.reduce(max) - listX.reduce(min);
    List<double> listY = intersectionPoints.map((e) => e.y).toList();
    double diffY = listY.reduce(max) - listY.reduce(min);
    debugPrint('diffX=$diffX,diffY=$diffY');
    if (diffX > diffY) {
      if ((intersectionPoints.elementAt(0).y - other.y).abs() <
          (intersectionPoints.elementAt(0).y - other.y - other.size.y).abs()) {
        hitEdge = 0;
      } else {
        hitEdge = 2;
      }
    } else {
      if ((intersectionPoints.elementAt(0).x - other.x).abs() <
          (intersectionPoints.elementAt(0).x - other.x - other.size.x).abs()) {
        hitEdge = 3;
      } else {
        hitEdge = 1;
      }
    }
    debugPrint('hitEdge=$hitEdge');
    if (hitEdge == 0) {
      if (jumpSpeed != 0) {
        jumpSpeed = 0;
        groundHeight -= other.size.y;
      }
    } else if (hitEdge == 3) {
      x = other.position.x - size.x;
    } else if (hitEdge == 1) {
      x = other.position.x + other.size.x;
    }
    if (other is ColliderBlock) {
    } else if (other is BrickBlock) {
    } else if (other is QuestionBlock) {
      if (hitEdge == 2) {
        jumpSpeed = -jumpSpeed;
      }
    }
  }
}

enum MarioStatus {
  initial,
  normal,
  normalFlip,
  forwardWalking,
  backwardWalking,
  skid,
  jump,
}
