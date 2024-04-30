import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_event.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/objects/app_container.dart';

class ChessGame extends FlameGame {
  late StatsBloc bloc;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'chinese_chess/background.jpg',
      'chinese_chess/background_home.jpg',
      'chinese_chess/chessboard.png',
      'chinese_chess/logo.png',
      'chinese_chess/pieces.png',
      'chinese_chess/river.png',
      'chinese_chess/shadow.png',
    ]);
    Dimension.containerMaxWidth = size.x < Dimension.containerMaxWidth
        ? size.x
        : Dimension.containerMaxWidth / size.y > 0.65
            ? size.y * 0.65
            : Dimension.containerMaxWidth;
    Dimension.blackBlockSize = Dimension.containerMaxWidth * 0.0335;
    Dimension.blackBlockPadding = Dimension.blackBlockSize * 0.093;
    AppContainer appContainer = AppContainer(
      position: size / 2,
      size: Vector2(Dimension.containerMaxWidth, size.y),
      anchor: Anchor.center,
      paint: BasicPalette.transparent.paint(),
    );
    bloc = StatsBloc();
    await add(
      FlameBlocProvider<StatsBloc, StatsState>(
        create: () => bloc,
        children: [appContainer],
      ),
    );
  }
}
