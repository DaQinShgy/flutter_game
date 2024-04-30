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

class GameDying extends StatsEvent {
  const GameDying();

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

class FastCountDown extends StatsEvent {
  const FastCountDown();

  @override
  List<Object?> get props => [];
}

class CountDown extends StatsEvent {
  const CountDown();

  @override
  List<Object?> get props => [];
}

class ScoreCoin extends StatsEvent {
  const ScoreCoin();

  @override
  List<Object?> get props => [];
}

class ScoreEnemy extends StatsEvent {
  const ScoreEnemy();

  @override
  List<Object?> get props => [];
}

class ScoreMushroom extends StatsEvent {
  const ScoreMushroom();

  @override
  List<Object?> get props => [];
}

class ScoreTime extends StatsEvent {
  const ScoreTime();

  @override
  List<Object?> get props => [];
}

class LiveMushroom extends StatsEvent {
  const LiveMushroom();

  @override
  List<Object?> get props => [];
}

class ResetLives extends StatsEvent {
  const ResetLives();

  @override
  List<Object?> get props => [];
}
