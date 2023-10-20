import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/brick_block.dart';
import 'package:flutter_game/mario/objects/coin_box_block.dart';

class GameBackground extends SpriteComponent
    with HasGameRef<MarioGame>, FlameBlocListenable<StatsBloc, StatsState> {
  GameBackground({super.size}) : super(position: Vector2(0, 0));

  /// Brick vector list
  List<Vector2> brickVectorList = [
    Vector2(20, 4),
    Vector2(22, 4),
    Vector2(24, 4),
  ];

  /// Coin box vector list
  List<Vector2> coinBoxVectorList = [
    Vector2(16, 4),
    Vector2(21, 4),
    Vector2(22, 8),
    Vector2(23, 4),
  ];

  @override
  FutureOr<void> onLoad() {
    // 3392 x 224
    // Ground height: 24
    sprite = Sprite(game.images.fromCache('mario/level_1.png'));

    // _buildBlock();
  }

  void _buildBlock() {
    addAll(
      brickVectorList.map(
        (e) => BrickBlock(
          position: Vector2(
            e.x * 16 * game.unitSize,
            game.groundHeight - e.y * 16 * game.unitSize,
          ),
        ),
      ),
    );
    addAll(
      coinBoxVectorList.map(
        (e) => CoinBoxBlock(
          position: Vector2(
            e.x * 16 * game.unitSize,
            game.groundHeight - e.y * 16 * game.unitSize,
          ),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    Vector2 velocity = Vector2.zero();
    velocity.x = game.objectSpeed;
    position += velocity * dt;
  }

  @override
  void onInitialState(StatsState state) {
    super.onInitialState(state);
    if (state.status == GameStatus.initial) {}
  }
}
