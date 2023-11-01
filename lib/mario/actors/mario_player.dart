import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';

class MarioPlayer extends SpriteAnimationComponent
    with
        HasGameRef<MarioGame>,
        KeyboardHandler,
        CollisionCallbacks,
        FlameBlocListenable<StatsBloc, StatsState> {
  MarioPlayer({super.position}) : super(anchor: Anchor.bottomLeft);

  @override
  bool get debugMode => true;

  late Image image;

  MarioStatus _status = MarioStatus.initial;

  int horizontalDirection = 0;

  final Vector2 velocity = Vector2.zero();

  double moveSpeed = 0;

  final double moveSpeedMax = 180;

  final double moveAccel = 10;

  //Vector for normal small mario
  List<List<Vector2>> normalSmallVector = [
    [Vector2(178, 32), Vector2(12, 16)],
  ];

  //Vector for normal small mario walking
  List<List<Vector2>> normalSmallWalkingVector = [
    [Vector2(80, 32), Vector2(15, 16)],
    [Vector2(96, 32), Vector2(16, 16)],
    [Vector2(112, 32), Vector2(16, 16)],
  ];

  //Vector for normal small mario skid
  List<List<Vector2>> normalSmallSkidVector = [
    [Vector2(130, 32), Vector2(14, 16)],
  ];

  @override
  FutureOr<void> onLoad() {
    image = game.images.fromCache('mario/mario_bros.png');
    add(RectangleHitbox());
    _loadStatus(MarioStatus.normal);
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
        break;
      default:
        break;
    }
  }

  SpriteAnimation _getAnimation(List<List<Vector2>> list) {
    return SpriteAnimation.spriteList(
      list.map((e) => Sprite(image, srcPosition: e[0], srcSize: e[1])).toList(),
      stepTime: 0.1,
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (bloc.state.status != GameStatus.running) {
      return true;
    }
    if (event is RawKeyUpEvent) {
      horizontalDirection = 0;
    } else {
      if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        horizontalDirection = -1;
      } else if ((keysPressed.contains(LogicalKeyboardKey.keyD) ||
          keysPressed.contains(LogicalKeyboardKey.arrowRight))) {
        horizontalDirection = 1;
      }
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (moveSpeed == 0) {
      if (horizontalDirection > 0) {
        _loadStatus(MarioStatus.walking);
        if (scale.x < 0) {
          flipHorizontallyAroundCenter();
        }
      } else if (horizontalDirection < 0) {
        _loadStatus(MarioStatus.walking);
        if (scale.x > 0) {
          flipHorizontallyAroundCenter();
        }
      } else {
        _loadStatus(MarioStatus.normal);
      }
    }
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

    velocity.x = moveSpeed;
    if (position.x + (velocity * dt).x - size.x <=
        game.cameraComponent.viewfinder.position.x) {
      // Prevent Mario from going backwards at screen edge.
      position = Vector2(
          game.cameraComponent.viewfinder.position.x + size.x, position.y);
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
    position += velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    debugPrint('intersectionPoints0=$intersectionPoints');
    // debugPrint('other=$other');
    if (other is ColliderBlock) {
      position = Vector2(other.position.x - size.x, position.y);
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
