import 'package:equatable/equatable.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
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

class GameOver extends StatsEvent {
  const GameOver();

  @override
  List<Object?> get props => [];
}

class GameScore extends StatsEvent {
  const GameScore(this.score);

  final double score;

  @override
  List<Object?> get props => [score];
}

class GameVictory extends StatsEvent {
  const GameVictory();

  @override
  List<Object?> get props => [];
}

class RaiseFlag extends StatsEvent {
  const RaiseFlag();

  @override
  List<Object?> get props => [];
}
