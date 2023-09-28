import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/objects/app_container.dart';
import 'package:flame_bloc/flame_bloc.dart';

class TerisGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await images.loadAll(['tetris.png']);
    AppContainer appContainer = AppContainer(
      position: size / 2,
      size: Vector2(Dimension.containerMaxWidth, size.y),
      anchor: Anchor.center,
      paint: BasicPalette.transparent.paint(),
    );
    await add(
      FlameBlocProvider<StatsBloc, StatsState>(
        create: () => StatsBloc(),
        children: [appContainer],
      ),
    );
  }

  @override
  Color backgroundColor() => const Color(0xFF009688);
}
