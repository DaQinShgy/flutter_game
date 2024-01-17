import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game/mario/bloc/stats_event.dart';
import 'package:flutter_game/mario/bloc/stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(const StatsState.empty()) {
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

    on<GameOver>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.over),
      ),
    );

    on<GameVictory>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.victory),
      ),
    );

    on<CountDown>(
      (event, emit) => emit(
        state.copyWith(
          time: state.time > 0 ? state.time - 1 : 0,
        ),
      ),
    );

    on<ScoreCoin>(
      (event, emit) => emit(
        state.copyWith(
          score: state.score + 200,
          coin: state.coin + 1,
        ),
      ),
    );

    on<ScoreEnemy>(
      (event, emit) => emit(
        state.copyWith(
          score: state.score + 100,
        ),
      ),
    );

    on<ScoreMushroom>(
      (event, emit) => emit(
        state.copyWith(
          score: state.score + 1000,
        ),
      ),
    );
  }
}
