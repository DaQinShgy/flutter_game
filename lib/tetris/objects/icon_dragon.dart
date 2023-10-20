import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/tetris/tetris_game.dart';

class IconDragon extends SpriteAnimationGroupComponent<DragonState>
    with HasGameRef<TetrisGame> {
  IconDragon({super.position, super.size});

  int runningCount = 0;

  @override
  FutureOr<void> onLoad() async {
    final blinkSprite0 = Sprite(
      game.images.fromCache('tetris/tetris.png'),
      srcPosition: Vector2(0, 100),
      srcSize: Vector2(80, 86),
    );
    final blinkSprite1 = Sprite(
      game.images.fromCache('tetris/tetris.png'),
      srcPosition: Vector2(100, 100),
      srcSize: Vector2(80, 86),
    );
    final idleAnim = SpriteAnimation.variableSpriteList(
      [blinkSprite0],
      stepTimes: [2],
      loop: false,
    );
    final blinkAnim = SpriteAnimation.variableSpriteList(
      [
        blinkSprite0,
        blinkSprite1,
        blinkSprite0,
        blinkSprite1,
        blinkSprite0,
        blinkSprite1,
        blinkSprite0,
      ],
      stepTimes: [1.5, 1.5, 0.2, 0.2, 0.2, 0.2, 0.2],
      loop: false,
    );
    final runningSprite0 = Sprite(
      game.images.fromCache('tetris/tetris.png'),
      srcPosition: Vector2(200, 100),
      srcSize: Vector2(80, 86),
    );
    final runningSprite1 = Sprite(
      game.images.fromCache('tetris/tetris.png'),
      srcPosition: Vector2(300, 100),
      srcSize: Vector2(80, 86),
    );
    final runningAnim = SpriteAnimation.spriteList(
        [runningSprite0, runningSprite1],
        stepTime: 0.1);
    animations = {
      DragonState.idle: idleAnim,
      DragonState.blink: blinkAnim,
      DragonState.running: runningAnim,
    };
    current = DragonState.idle;

    animationTickers?[DragonState.idle]?.onComplete = () {
      current = DragonState.blink;
    };
    animationTickers?[DragonState.blink]?.onComplete = () {
      runningCount = 0;
      current = DragonState.running;
    };
    animationTickers?[DragonState.running]?.onFrame = (currentIndex) {
      if (currentIndex == 1) {
        runningCount++;
        if (runningCount % 10 == 0) {
          if (runningCount >= 40) {
            current = DragonState.idle;
            animationTickers?.forEach((key, value) {
              value.reset();
            });
          } else {
            flipHorizontallyAroundCenter();
          }
        }
      }
    };
  }
}

enum DragonState { idle, blink, running }
