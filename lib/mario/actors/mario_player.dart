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

  bool isFlip = false;

  int horizontalDirection = 0;

  int verticalDirection = 0;

  double moveSpeed = 0;

  final double moveSpeedMax = 180;

  final double moveAccel = 10;

  double jumpSpeed = 0;

  final double gravityAccel = 800;

  double groundHeight = 0;

  double platformHeight = 0;

  bool get isOnPlatform => (y >= platformHeight);

  PositionComponent? _currentPlatform;

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
    groundHeight = y;
    platformHeight = y;
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
      case MarioStatus.walking:
        animation = _getAnimation(normalSmallWalkingVector);
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

  SpriteAnimation _getAnimation(List<List<double>> list) {
    return SpriteAnimation.spriteList(
      list
          .map((e) => FlipSprite(
                image,
                isFlip,
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
        if (isOnPlatform) {
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
    if (isOnPlatform) {
      y = platformHeight;
      jumpSpeed = 0;

      if (horizontalDirection > 0) {
        _loadStatus(MarioStatus.walking);
      } else if (horizontalDirection < 0) {
        _loadStatus(MarioStatus.walking);
      } else {
        _loadStatus(MarioStatus.normal);
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
    if (x + moveSpeed * dt <= game.cameraComponent.viewfinder.position.x) {
      // Prevent Mario from going backwards at screen edge.
      x = game.cameraComponent.viewfinder.position.x;
      return;
    }
    double halfScreenWidth = game.size.x / game.scaleSize / 2;
    if (x + width >=
            game.cameraComponent.viewfinder.position.x + halfScreenWidth &&
        horizontalDirection > 0) {
      // Viewfinder moves to the right
      game.cameraComponent.viewfinder.position =
          Vector2(x + width - halfScreenWidth, 0);
    }
    x += moveSpeed * dt;

    //Check mario is at the top of currentPlatform
    if (_currentPlatform != null) {
      if (platformHeight == groundHeight - _currentPlatform!.height) {
        if (x <= _currentPlatform!.x - width ||
            x >= _currentPlatform!.x + _currentPlatform!.width) {
          platformHeight = groundHeight;
          jumpSpeed = 1;
        }
      }
      if (platformHeight == groundHeight) {
        _currentPlatform = null;
      }
    }
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
          (intersectionPoints.elementAt(0).y - other.y - other.height).abs()) {
        hitEdge = 0;
      } else {
        hitEdge = 2;
      }
    } else {
      if ((intersectionPoints.elementAt(0).x - other.x).abs() <
          (intersectionPoints.elementAt(0).x - other.x - other.width).abs()) {
        hitEdge = 3;
      } else {
        hitEdge = 1;
      }
    }
    debugPrint('hitEdge=$hitEdge');
    if (hitEdge == 0) {
      _currentPlatform = other;
      if (jumpSpeed != 0) {
        jumpSpeed = 0;
        platformHeight -= other.height;
      }
    } else if (hitEdge == 1) {
      x = other.x + other.width;
    } else if (hitEdge == 3) {
      moveSpeed = 0;
      x = other.x - width;
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
  walking,
  skid,
  jump,
}
