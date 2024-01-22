import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
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

  Component? scoreLabel;

  late Component coinIcon;

  Component? coinCount;

  Component? time;

  late SpriteComponent spriteComponentBoard;

  late PositionComponent mushrooms;

  int playerCount = 1;

  late Component player1;

  late Component player2;

  late Component top;

  late Component blackBg;

  late Component level;

  late Component mario;

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
    double topMargin = 11 * game.scaleSize;
    add(_buildLabel('MARIO', Vector2(centerX - 16 * 8 * game.scaleSize, topMargin)));
    add(_buildLabel('WORLD', Vector2(centerX + 16 * game.scaleSize, topMargin)));
    add(_buildLabel('TIME', Vector2(centerX + 16 * 6 * game.scaleSize, topMargin)));
    add(_buildLabel('1-1', Vector2(centerX + 22 * game.scaleSize, topMargin * 2)));

    coinIcon = CoinIcon(
      CoinType.twinkle,
      position: Vector2(centerX - 16 * 3 * game.scaleSize, 21.5 * game.scaleSize),
      scale: scale * game.scaleSize / 2,
    );
    add(coinIcon);
    add(_buildLabel('*', Vector2(centerX - (16 * 3 - 6) * game.scaleSize, 21 * game.scaleSize)));

    spriteComponentBoard = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('mario/title_screen.png'),
        srcSize: Vector2(176, 88),
        srcPosition: Vector2(1, 60),
      ),
      anchor: Anchor.topCenter,
      scale: scale * game.scaleSize,
      position: Vector2(centerX, 35 * game.scaleSize),
    );
    add(spriteComponentBoard);
    mushrooms = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('mario/title_screen.png'),
        srcSize: Vector2(8, 8),
        srcPosition: Vector2(3, 155),
      ),
      scale: scale * game.scaleSize,
      position: Vector2(centerX - 16 * 4 * game.scaleSize, 140 * game.scaleSize),
    );
    add(mushrooms);
    player1 = _buildLabel('1 PLAYER GAME', Vector2(centerX - 16 * 2.5 * game.scaleSize, 140.5 * game.scaleSize));
    add(player1);
    player2 = _buildLabel(
        '2 PLAYER GAME - COMING SOON', Vector2(centerX - 16 * 2.5 * game.scaleSize, 160.5 * game.scaleSize));
    add(player2);
    top = _buildLabel('TOP - 000000', Vector2(centerX - 16 * 2 * game.scaleSize, 180 * game.scaleSize));
    add(top);

    blackBg = HudBackground(size: size);
    level = _buildLabel('WORLD   1-1  ', Vector2(centerX - 6 * 7 * game.scaleSize, 80 * game.scaleSize));
    mario = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('mario/mario_bros.png'),
        srcSize: Vector2(15, 16),
        srcPosition: Vector2(178, 32),
      ),
      scale: scale * game.scaleSize,
      position: Vector2(centerX - 35 * game.scaleSize, 110 * game.scaleSize),
    );
  }

  PositionComponent _buildLabel(String string, Vector2 position) {
    List<Component> list = [];
    Image image = game.images.fromCache('mario/text_images.png');
    for (int i = 0; i < string.length; i++) {
      Vector2 vector2 = characterMap[string[i]] ?? Vector2(0, 0);
      list.add(SpriteComponent(
        sprite: Sprite(
          image,
          srcPosition: vector2,
          srcSize: Vector2(7, 7),
        ),
        position: Vector2(i * 8, 0),
        // scale: scale * game.scaleSize,
      ));
    }
    return PositionComponent(
      position: position,
      scale: scale * game.scaleSize,
      children: list,
    );
  }

  bool firstUpdate = true;

  @override
  void update(double dt) {
    timer?.update(dt);
    if (firstUpdate) {
      firstUpdate = false;
      _buildData();
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
            Vector2(size.x / 2 - 16 * 4 * game.scaleSize, (playerCount == 1 ? 140 : 160) * game.scaleSize);
      } else if (keysPressed.contains(LogicalKeyboardKey.enter)) {
        if (blackBg.parent != null) {
          return true;
        }
        if (playerCount == 1) {
          _buildPreview();
        }
      }
    }
    return true;
  }

  void _buildPreview() {
    if (spriteComponentBoard.parent != null) {
      removeAll([spriteComponentBoard, mushrooms, player1, player2, top]);
    }
    double centerX = size.x / 2;
    final health = _buildLabel('X   ${bloc.state.lives}', Vector2(centerX - 8 * game.scaleSize, 115 * game.scaleSize));
    addAll([blackBg, level, mario, health]);
    Future.delayed(const Duration(seconds: 1), () {
      removeAll([blackBg, level, mario, health]);
      bloc.add(const GameRunning());
      _startTimer();
    });
  }

  Timer? timer;

  void _startTimer() {
    timer = Timer(0.5, repeat: true, onTick: () {
      if (bloc.state.status == GameStatus.running) {
        bloc.add(const CountDown());
      }
    }, autoStart: true);
  }

  @override
  void onNewState(StatsState state) {
    super.onNewState(state);
    if (state.status == GameStatus.over) {
      _buildPreview();
    } else {
      _buildData();
      if (bloc.state.time <= 0) {
        game.marioPlayer.death();
      }
    }
  }

  void _buildData() {
    double centerX = size.x / 2;

    scoreLabel?.removeFromParent();
    scoreLabel = _buildLabel(
      bloc.state.score.toString().padLeft(6, '0'),
      Vector2(centerX - 16 * 8 * game.scaleSize, 21 * game.scaleSize),
    );
    add(scoreLabel!);

    coinCount?.removeFromParent();
    coinCount = _buildLabel(bloc.state.coin.toString().padLeft(2, '0'),
        Vector2(centerX - (16 * 3 - 14) * game.scaleSize, 21 * game.scaleSize));
    add(coinCount!);

    time?.removeFromParent();
    time = _buildLabel(
      bloc.state.time.toString().padLeft(3, '0'),
      Vector2(centerX + 14 + 16 * 6 * game.scaleSize, 21 * game.scaleSize),
    );
    add(time!);
  }
}
