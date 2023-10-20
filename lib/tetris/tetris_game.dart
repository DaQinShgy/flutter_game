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

class TetrisGame extends FlameGame with KeyboardEvents {
  late StatsBloc bloc;

  @override
  Future<void> onLoad() async {
    await images.loadAll(['tetris/tetris.png']);
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

  @override
  Color backgroundColor() => const Color(0xFF009688);

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyUpEvent) {
      return super.onKeyEvent(event, keysPressed);
    }
    switch (event.data.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        if (bloc.state.status == GameStatus.running) {
          bloc.add(const Rotation());
        } else if (bloc.state.status == GameStatus.initial) {
          bloc.add(const StartLineIncrease());
        }
        break;
      case LogicalKeyboardKey.arrowDown:
        if (bloc.state.status == GameStatus.running) {
          bloc.add(const Down());
        } else if (bloc.state.status == GameStatus.initial) {
          bloc.add(const StartLineDecrease());
        }
        break;
      case LogicalKeyboardKey.arrowLeft:
        if (bloc.state.status == GameStatus.running) {
          bloc.add(const Left());
        } else if (bloc.state.status == GameStatus.initial) {
          bloc.add(const LevelDecrease());
        }
        break;
      case LogicalKeyboardKey.arrowRight:
        if (bloc.state.status == GameStatus.running) {
          bloc.add(const Right());
        } else if (bloc.state.status == GameStatus.initial) {
          bloc.add(const LevelIncrease());
        }
        break;
      case LogicalKeyboardKey.space:
        if (bloc.state.status == GameStatus.initial ||
            bloc.state.status == GameStatus.pause) {
          bloc.add(const GameRunning());
        } else if (bloc.state.status == GameStatus.running) {
          bloc.add(const Drop());
        }
        break;
      case LogicalKeyboardKey.keyP:
        if (bloc.state.status == GameStatus.initial ||
            bloc.state.status == GameStatus.pause) {
          bloc.add(const GameRunning());
        } else if (bloc.state.status == GameStatus.running) {
          bloc.add(const GamePause());
        }
        break;
      case LogicalKeyboardKey.keyS:
        bloc.add(const Mute());
        break;
      case LogicalKeyboardKey.keyR:
        if (bloc.state.status == GameStatus.initial) {
          bloc.add(const GameRunning());
        } else if (bloc.state.status == GameStatus.running ||
            bloc.state.status == GameStatus.pause ||
            bloc.state.status == GameStatus.mixing) {
          bloc.add(const GameReset());
        }
        break;
      default:
        break;
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
