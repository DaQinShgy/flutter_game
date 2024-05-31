import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game/chinese_chess/bloc/stats_event.dart';
import 'package:flutter_game/chinese_chess/bloc/stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(const StatsState.empty()) {
    on<GameReset>(
      (event, emit) => emit(
        state.copyWith(status: GameStatus.reset),
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
  }
}
