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

class GamePause extends StatsEvent {
  const GamePause();

  @override
  List<Object?> get props => [];
}

class GameOver extends StatsEvent {
  const GameOver();

  @override
  List<Object?> get props => [];
}

class CoinScore extends StatsEvent {
  const CoinScore(this.score);

  final double score;

  @override
  List<Object?> get props => [score];
}
