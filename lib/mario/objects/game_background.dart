import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/brick_block.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';
import 'package:flutter_game/mario/objects/question_block.dart';

class GameBackground extends SpriteComponent
    with HasGameRef<MarioGame>, FlameBlocListenable<StatsBloc, StatsState> {
  GameBackground({super.size}) : super(position: Vector2(0, 0));

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('mario/level_1.png'));
    _buildCollider();
    _buildBlock();
  }

  void _buildBlock() {
    final questionBlocks =
        game.mapComponent.tileMap.getLayer<ObjectGroup>('question blocks');
    addAll(questionBlocks!.objects
        .map((object) => QuestionBlock(
              position: Vector2(object.x, object.y),
            ))
        .toList());
    final brickBlocks =
        game.mapComponent.tileMap.getLayer<ObjectGroup>('brick blocks');
    addAll(brickBlocks!.objects
        .map((object) => BrickBlock(
              position: Vector2(object.x, object.y),
            ))
        .toList());
  }

  void _buildCollider() {
    final collider =
        game.mapComponent.tileMap.getLayer<ObjectGroup>('collider');
    addAll(
      collider!.objects.map(
        (object) => ColliderBlock(
          position: Vector2(object.x, object.y),
          size: Vector2(object.width, object.height),
        ),
      ),
    );
  }

  @override
  void onInitialState(StatsState state) {
    super.onInitialState(state);
    if (state.status == GameStatus.initial) {}
  }

  @override
  bool listenWhen(StatsState previousState, StatsState newState) {
    if (previousState.status == GameStatus.initial &&
        newState.status == GameStatus.running) {
      // _buildBlock();
    }
    return super.listenWhen(previousState, newState);
  }
}
