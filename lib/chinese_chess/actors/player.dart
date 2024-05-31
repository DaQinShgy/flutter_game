import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/chinese_chess/bloc/stats_bloc.dart';
import 'package:flutter_game/chinese_chess/bloc/stats_state.dart';
import 'package:flutter_game/chinese_chess/chess_game.dart';

class Player extends PositionComponent
    with HasGameRef<ChessGame>, FlameBlocReader<StatsBloc, StatsState> {
  Player(
    this._type, {
    super.size,
    super.position,
    super.anchor,
  });

  final PlayerType _type;

  final List<List<double>> _personVector = [
    [2, 2, 102, 102],
    [2, 108, 96, 96],
    [2, 208, 96, 96],
    [2, 308, 96, 96],
    [2, 408, 96, 96],
    [2, 508, 96, 96],
    [2, 608, 96, 96],
    [108, 2, 96, 96],
    [108, 102, 96, 96],
    [102, 202, 96, 96],
    [102, 302, 96, 96],
    [102, 402, 96, 96],
    [102, 502, 96, 96],
    [102, 602, 96, 96],
  ];

  final List<String> _levels = ['小白', '菜鸟', '入门', '初级', '中级', '高级', '精英', '特大'];

  @override
  Future<void> onLoad() {
    SpriteComponent frameSprite = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('chinese_chess/objects1.png'),
        srcSize: Vector2(66, 66),
        srcPosition:
            _type == PlayerType.right ? Vector2(643, 219) : Vector2(643, 363),
      ),
      size: Vector2(size.x, size.x),
    );
    List<double> randomVector =
        _personVector[Random().nextInt(_personVector.length)];
    SpriteComponent characterSprite = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('chinese_chess/character.png'),
        srcPosition: Vector2(randomVector[0], randomVector[1]),
        srcSize: Vector2(randomVector[2], randomVector[3]),
      ),
      position: Vector2(size.x * 0.07, size.x * 0.07),
      size: Vector2(size.x * 0.86, size.x * 0.86),
    );
    addAll([frameSprite, characterSprite]);
    return super.onLoad();
  }

  @override
  void onMount() {
    TextComponent text = TextComponent(
      position: Vector2(size.x / 2, size.y),
      anchor: Anchor.topCenter,
      text: _type == PlayerType.right && bloc.state.first
          ? '${bloc.state.step}步'
          : _levels[bloc.state.level],
      textRenderer: TextPaint(
        style: TextStyle(
          color: const Color(0xFFD2C1AD),
          fontSize: size.x / 3.5,
        ),
      ),
    );
    add(text);
    super.onMount();
  }
}

enum PlayerType { left, right }
