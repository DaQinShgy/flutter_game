import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_event.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/coin_icon.dart';
import 'package:flutter_game/mario/overlays/hud_background.dart';

class Hub extends PositionComponent
    with HasGameRef<MarioGame>, FlameBlocListenable<StatsBloc, StatsState>, KeyboardHandler {
  Hub({super.position, super.size});

  late Component scoreLabel;

  late Component coinIcon;

  late Component coinCount;

  late SpriteComponent spriteComponentBoard;

  late PositionComponent mushrooms;

  int playerCount = 1;

  late Component player1;

  late Component player2;

  late Component top;

  late Component blackBg;

  late Component level;

  late Component mario;

  late Component health;

  /// Character vector
  Map<String, Vector2> characterMap = {
    '0': Vector2(3, 230),
    '1': Vector2(11.5, 230),
    '2': Vector2(19, 230),
    '3': Vector2(27, 230),
    '4': Vector2(35, 230),
    '5': Vector2(43, 230),
    '6': Vector2(51, 230),
    '7': Vector2(59, 230),
    '8': Vector2(67, 230),
    '9': Vector2(75, 230),
    'A': Vector2(83, 230),
    'B': Vector2(91, 230),
    'C': Vector2(99, 230),
    'D': Vector2(107, 230),
    'E': Vector2(115, 230),
    'F': Vector2(123, 230),
    'G': Vector2(3, 238),
    'H': Vector2(11, 238),
    'I': Vector2(20, 238),
    'J': Vector2(27, 238),
    'K': Vector2(35, 238),
    'L': Vector2(43.5, 238),
    'M': Vector2(51, 238),
    'N': Vector2(59, 238),
    'O': Vector2(67, 238),
    'P': Vector2(75, 238),
    'Q': Vector2(83, 238),
    'R': Vector2(91, 238),
    'S': Vector2(99, 238),
    'T': Vector2(107.7, 238),
    'U': Vector2(115, 238),
    'V': Vector2(123, 238),
    'W': Vector2(3, 246),
    'X': Vector2(11, 246),
    'Y': Vector2(20, 246),
    'Z': Vector2(27, 246),
    ' ': Vector2(48, 248),
    '-': Vector2(67.5, 246.5),
    '*': Vector2(75, 247),
  };

  @override
  FutureOr<void> onLoad() async {
    double centerX = size.x / 2;
    double topMargin = 11 * game.unitSize;
    add(_buildLabel('MARIO', Vector2(centerX - 16 * 8 * game.unitSize, topMargin)));
    add(_buildLabel('WORLD', Vector2(centerX + 16 * game.unitSize, topMargin)));
    add(_buildLabel('TIME', Vector2(centerX + 16 * 6 * game.unitSize, topMargin)));
    add(_buildLabel('1-1', Vector2(centerX + 22 * game.unitSize, topMargin * 2)));
    scoreLabel = _buildLabel(
      '000000',
      Vector2(centerX - 16 * 8 * game.unitSize, 21 * game.unitSize),
    );
    add(scoreLabel);
    coinIcon = CoinIcon(
      position: Vector2(centerX - 16 * 4 * game.unitSize, 21.5 * game.unitSize),
    );
    add(coinIcon);
    add(_buildLabel('*', Vector2(centerX - (16 * 4 - 6) * game.unitSize, 21 * game.unitSize)));
    coinCount = _buildLabel('00', Vector2(centerX - (16 * 4 - 14) * game.unitSize, 21 * game.unitSize));
    add(coinCount);

    spriteComponentBoard = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('mario/title_screen.png'),
        srcSize: Vector2(176, 88),
        srcPosition: Vector2(1, 60),
      ),
      anchor: Anchor.topCenter,
      scale: scale * game.unitSize,
      position: Vector2(centerX, 35 * game.unitSize),
    );
    add(spriteComponentBoard);
    mushrooms = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('mario/title_screen.png'),
        srcSize: Vector2(8, 8),
        srcPosition: Vector2(3, 155),
      ),
      scale: scale * game.unitSize,
      position: Vector2(centerX - 16 * 4 * game.unitSize, 140 * game.unitSize),
    );
    add(mushrooms);
    player1 = _buildLabel('1 PLAYER GAME', Vector2(centerX - 16 * 2.5 * game.unitSize, 140.5 * game.unitSize));
    add(player1);
    player2 =
        _buildLabel('2 PLAYER GAME - COMING SOON', Vector2(centerX - 16 * 2.5 * game.unitSize, 160.5 * game.unitSize));
    add(player2);
    top = _buildLabel('TOP - 000000', Vector2(centerX - 16 * 2 * game.unitSize, 180 * game.unitSize));
    add(top);

    blackBg = HudBackground(size: size);
    level = _buildLabel('WORLD   1-1  ', Vector2(centerX - 6 * 7 * game.unitSize, 80 * game.unitSize));
    mario = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('mario/mario_bros.png'),
        srcSize: Vector2(15, 16),
        srcPosition: Vector2(178, 32),
      ),
      scale: scale * game.unitSize,
      position: Vector2(centerX - 35 * game.unitSize, 110 * game.unitSize),
    );
    health = _buildLabel('X   3', Vector2(centerX - 8 * game.unitSize, 115 * game.unitSize));
  }

  PositionComponent _buildLabel(String string, Vector2 position, {Anchor anchor = Anchor.topLeft}) {
    SpriteBatch spriteBatch = SpriteBatch(game.images.fromCache('mario/text_images.png'));
    for (int i = 0; i < string.length; i++) {
      Vector2 vector2 = characterMap[string[i]] ?? Vector2(0, 0);
      spriteBatch.add(
        source: Rect.fromLTWH(vector2.x, vector2.y, 7, 7),
        offset: Vector2(i * 7, 0),
      );
    }
    return PositionComponent(
      position: position,
      scale: scale * game.unitSize,
      children: [SpriteBatchComponent(spriteBatch: spriteBatch)],
    );
  }

  bool firstUpdate = true;

  @override
  void update(double dt) {
    if (firstUpdate) {
      firstUpdate = false;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (bloc.state.status == GameStatus.initial) {
      if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
          keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyS) ||
          keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        playerCount = playerCount == 1 ? 2 : 1;
        mushrooms.position =
            Vector2(size.x / 2 - 16 * 4 * game.unitSize, (playerCount == 1 ? 140 : 160) * game.unitSize);
      } else if (keysPressed.contains(LogicalKeyboardKey.enter)) {
        if (blackBg.parent != null) {
          return true;
        }
        if (playerCount == 1) {
          _buildData();
        }
      }
    }
    return true;
  }

  Future<void> _buildData() async {
    removeAll([spriteComponentBoard, mushrooms, player1, player2, top]);
    addAll([blackBg, level, mario, health]);
    await Future.delayed(const Duration(seconds: 2));
    removeAll([blackBg, level, mario, health]);
    bloc.add(const GameRunning());
  }
}
