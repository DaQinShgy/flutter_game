import 'package:equatable/equatable.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
}

class GameReset extends StatsEvent {
  const GameReset();

  @override
  List<Object?> get props => [];
}

class GameInitial extends StatsEvent {
  const GameInitial();

  @override
  List<Object?> get props => [];
}

class GameRunning extends StatsEvent {
  const GameRunning();

  @override
  List<Object?> get props => [];
}

class GamePause extends StatsEvent {
  const GamePause();

  @override
  List<Object?> get props => [];
}