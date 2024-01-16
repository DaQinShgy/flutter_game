import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/brick_block.dart';
import 'package:flutter_game/mario/objects/castle_flag.dart';
import 'package:flutter_game/mario/objects/collider_block.dart';
import 'package:flutter_game/mario/objects/enemy_goomba.dart';
import 'package:flutter_game/mario/objects/enemy_koopa.dart';
import 'package:flutter_game/mario/objects/flag_pole.dart';
import 'package:flutter_game/mario/objects/ground_block.dart';
import 'package:flutter_game/mario/objects/question_block.dart';

class GameBackground extends SpriteComponent
    with HasGameRef<MarioGame>, FlameBlocListenable<StatsBloc, StatsState> {
  GameBackground({super.size}) : super(position: Vector2(0, 0));

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('mario/level_1.png'));
    _buildCollider();
    _buildBlock();
    _buildEnemies();
    _buildGround();
    _buildFlagPole();
    _buildCastle();
  }

  void _buildBlock() {
    final questionBlocks =
        game.mapComponent.tileMap.getLayer<ObjectGroup>('question blocks');
    addAll(questionBlocks!.objects.map((object) => QuestionBlock(
          object.type == 'coin'
              ? QuestionType.coin
              : object.type == 'red mushroom'
                  ? QuestionType.redMushroom
                  : object.type == 'green mushroom'
                      ? QuestionType.greenMushroom
                      : object.type == 'flower'
                          ? QuestionType.flower
                          : object.type == 'mushroom flower'
                              ? QuestionType.mushroomFlower
                              : QuestionType.star,
          object.id,
          position: Vector2(object.x, object.y),
        )));
    final brickBlocks =
        game.mapComponent.tileMap.getLayer<ObjectGroup>('brick blocks');
    addAll(brickBlocks!.objects.map((object) => BrickBlock(
          object.type,
          position: Vector2(object.x, object.y),
        )));
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

  void _buildEnemies() {
    final enemies = game.mapComponent.tileMap.getLayer<ObjectGroup>('enemies');
    addAll(enemies!.objects.map((object) {
      if (object.type == 'goomba') {
        return EnemyGoomba(object.name, position: Vector2(object.x, object.y));
      } else {
        return EnemyKoopa(position: Vector2(object.x, object.y));
      }
    }));
  }

  void _buildGround() {
    final grounds = game.mapComponent.tileMap.getLayer<ObjectGroup>('grounds');
    addAll(grounds!.objects.map((object) => GroundBlock(
        position: Vector2(object.x, object.y),
        size: Vector2(object.width, object.height))));
  }

  void _buildFlagPole() {
    final group = game.mapComponent.tileMap.getLayer<ObjectGroup>('flagpole');
    addAll(group!.objects.map((object) {
      if (object.type == 'pole') {
        return Pole(position: Vector2(object.x, object.y));
      } else if (object.type == 'flag') {
        return Flag(position: Vector2(object.x, object.y));
      } else if (object.type == 'finial') {
        return Finial(position: Vector2(object.x, object.y));
      }
      return Component();
    }));
  }

  void _buildCastle() {
    final castle = game.mapComponent.tileMap.getLayer<ObjectGroup>('castle');
    addAll(castle!.objects.map((object) {
      if (object.type == 'flag') {
        return CastleFlag(
          position: Vector2(object.x, object.y),
        );
      }
      return Component();
    }));
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
