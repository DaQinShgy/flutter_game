import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_event.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsState.empty()) {
    on<GameReset>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.reset, score: 0, cleanLine: 0),
      ),
    );

    on<GameInitial>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.initial),
      ),
    );

    on<GameRunning>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.running),
      ),
    );

    on<GamePause>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.pause),
      ),
    );

    on<GameMixing>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.mixing),
      ),
    );

    on<LevelIncrease>(
      (event, emit) {
        add(LevelEvent(state.level >= 6 ? 1 : state.level + 1));
      },
    );

    on<LevelDecrease>(
      (event, emit) {
        add(LevelEvent(state.level <= 1 ? 6 : state.level - 1));
      },
    );

    on<StartLineIncrease>(
      (event, emit) {
        add(StartLineEvent(state.startLine >= 10 ? 0 : state.startLine + 1));
      },
    );

    on<StartLineDecrease>(
      (event, emit) {
        add(StartLineEvent(state.startLine <= 0 ? 10 : state.startLine - 1));
      },
    );
  }
}
