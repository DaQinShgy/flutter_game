import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';

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
  final double moveSpeed = 200;

  //Vector for normal small mario
  List<List<Vector2>> normalSmallVector = [
    [Vector2(178, 32), Vector2(12, 16)],
  ];

  //Vector for normal small mario walking
  List<List<Vector2>> normalSmallWalkingVector = [
    [Vector2(178, 32), Vector2(12, 16)],
    [Vector2(80, 32), Vector2(15, 16)],
    [Vector2(96, 32), Vector2(16, 16)],
    [Vector2(112, 32), Vector2(16, 16)],
  ];

  @override
  FutureOr<void> onLoad() {
    scale = scale * game.unitSize;
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
      case MarioStatus.jump:
        break;
      default:
        break;
    }
  }

  SpriteAnimation _getAnimation(List<List<Vector2>> list) {
    return SpriteAnimation.spriteList(
      list.map((e) => Sprite(image, srcPosition: e[0], srcSize: e[1])).toList(),
      stepTime: 0.12,
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (bloc.state.status != GameStatus.running) {
      return true;
    }
    if (event is RawKeyUpEvent) {
      _loadStatus(MarioStatus.normal);
      horizontalDirection = 0;
    } else {
      if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        _loadStatus(MarioStatus.walking);
        horizontalDirection = -1;
        if (scale.x > 0) {
          flipHorizontallyAroundCenter();
        }
      } else if ((keysPressed.contains(LogicalKeyboardKey.keyD) ||
          keysPressed.contains(LogicalKeyboardKey.arrowRight))) {
        _loadStatus(MarioStatus.walking);
        horizontalDirection = 1;
        if (scale.x < 0) {
          flipHorizontallyAroundCenter();
        }
      }
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.x = horizontalDirection * moveSpeed;
    game.objectSpeed = 0;
    if (position.x - size.x * game.unitSize <= 0 && horizontalDirection < 0) {
      // Prevent Mario from going backwards at screen edge.
      velocity.x = 0;
    }
    if (position.x >= game.size.x / 2 && horizontalDirection > 0) {
      // Prevent Mario from going beyond half screen.
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }
    position += velocity * dt;
  }
}

enum MarioStatus {
  initial,
  normal,
  walking,
  jump,
}
