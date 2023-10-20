import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_event.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/mario/objects/coin_icon.dart';

class Hub extends PositionComponent
    with HasGameRef<MarioGame>, FlameBlocListenable<StatsBloc, StatsState> {
  Hub({super.position, super.size});

  late Image image;

  late Component scoreLabel;

  late Component coinIcon;

  late Component coinCount;

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
    'L': Vector2(44, 238),
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
    image = game.images.fromCache('mario/text_images.png');
    scale = scale * game.unitSize;
    add(_buildLabel('MARIO', Vector2(size.x / game.unitSize / 2 - 16 * 8, 11)));
    add(_buildLabel('WORLD', Vector2(size.x / game.unitSize / 2 + 16, 11)));
    add(_buildLabel('TIME', Vector2(size.x / game.unitSize / 2 + 16 * 6, 11)));
    add(_buildLabel('1-1', Vector2(size.x / game.unitSize / 2 + 22, 21)));
    scoreLabel = _buildLabel(
      '000000',
      Vector2(size.x / game.unitSize / 2 - 16 * 8, 21),
    );
    add(scoreLabel);
    coinIcon =
        CoinIcon(position: Vector2(size.x / game.unitSize / 2 - 16 * 4, 22));
    add(coinIcon);
    add(_buildLabel('*', Vector2(size.x / game.unitSize / 2 - 16 * 4 + 6, 22))
      ..scale = Vector2(0.8, 0.8));
    coinCount = _buildLabel(
        '00', Vector2(size.x / game.unitSize / 2 - 16 * 4 + 14, 21));
    add(coinCount);
  }

  PositionComponent _buildLabel(String string, Vector2 position) {
    SpriteBatch spriteBatch = SpriteBatch(image);
    for (int i = 0; i < string.length; i++) {
      Vector2 vector2 = characterMap[string[i]] ?? Vector2(0, 0);
      spriteBatch.add(
        source: Rect.fromLTWH(vector2.x, vector2.y, 7, 7),
        offset: Vector2(i * 7, 0),
      );
    }
    return PositionComponent(
      position: position,
      children: [SpriteBatchComponent(spriteBatch: spriteBatch)],
    );
  }

  bool firstUpdate = true;

  @override
  void update(double dt) {
    if (firstUpdate) {
      firstUpdate = false;
      bloc.on<CoinScore>((event, emit) => null);
    }
  }
}
