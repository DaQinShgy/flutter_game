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
  }
}
