import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';

import 'objects/app_container.dart';

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
      'chinese_chess/objects.png',
      'chinese_chess/objects1.png',
      'chinese_chess/character.png',
    ]);
    AppContainer appContainer = AppContainer(
      position: size / 2,
      size: size.y / size.x < 0.75
          ? Vector2(size.y / 0.75, size.y)
          : Vector2(size.x, size.x * 0.75), // h/w=0.75
      anchor: Anchor.center,
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
