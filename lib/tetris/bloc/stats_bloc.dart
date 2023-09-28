import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_event.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsState.empty()) {
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

    on<ScoreEvent>(
      (event, emit) => emit(
        state.copyWith(score: state.score + event.score),
      ),
    );

  }
}
