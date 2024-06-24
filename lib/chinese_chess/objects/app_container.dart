import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/chinese_chess/actors/player.dart';
import 'package:flutter_game/chinese_chess/bloc/stats_bloc.dart';
import 'package:flutter_game/chinese_chess/bloc/stats_state.dart';
import 'package:flutter_game/chinese_chess/chess_game.dart';
import 'package:flutter_game/chinese_chess/objects/chess_borad.dart';

import 'bottom_control.dart';

class AppContainer extends RectangleComponent
    with HasGameRef<ChessGame>, FlameBlocListenable<StatsBloc, StatsState> {
  AppContainer({
    super.position,
    super.size,
    super.anchor,
    super.paint,
  });

  @override
  FutureOr<void> onLoad() async {
    SpriteComponent spriteBg = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('chinese_chess/background.jpg'),
      ),
      size: size,
    );
    double chessboardHeight = size.y - size.y / 15 - size.y / 40;
    double chessboardWidth = chessboardHeight * 628 / 730;
    ChessBoard chessBoard = ChessBoard(
      size: Vector2(chessboardWidth, chessboardHeight),
      position: Vector2(size.x / 2, size.y / 40),
      anchor: Anchor.topCenter,
    );
    BottomControl bottomControl = BottomControl(
      size: Vector2(size.x, size.y / 13.5),
      position: Vector2(0, size.y),
    );
    Player playerLeft = Player(
      PlayerType.left,
      position: Vector2((size.x - chessboardWidth) / 4, size.y / 20),
      size: Vector2(
        (size.x - chessboardWidth) / 6,
        (size.x - chessboardWidth) / 6,
      ),
      anchor: Anchor.topCenter,
    );
    Player playerRight = Player(
      PlayerType.right,
      position: Vector2(
        size.x - (size.x - chessboardWidth) / 4,
        size.y - size.y / 8.5,
      ),
      size: Vector2(
        (size.x - chessboardWidth) / 6,
        (size.x - chessboardWidth) / 6,
      ),
      anchor: Anchor.bottomCenter,
    );
    addAll([
      spriteBg,
      chessBoard,
      playerLeft,
      playerRight,
      bottomControl,
    ]);
  }

  PositionComponent _buildConfig() {
    RectangleComponent bgComponent = RectangleComponent(
      size: size * 0.6,
      position: size * 0.2,
    );
    bgComponent.setColor(Colors.black.withOpacity(0.15));
    TextComponent levelComponent = TextComponent(
      text: '难度设定',
      position: Vector2(size.x / 2, size.y / 10 / 2),
    );
    bgComponent.add(levelComponent);
    return bgComponent;
  }
}
