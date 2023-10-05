import 'package:equatable/equatable.dart';
import 'package:flutter_game/tetris/objects/block_unit.dart';

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

class GameMixing extends StatsEvent {
  const GameMixing();

  @override
  List<Object?> get props => [];
}

class ScoreEvent extends StatsEvent {
  const ScoreEvent(this.score);

  final int score;

  @override
  List<Object?> get props => [score];
}

class LineEvent extends StatsEvent {
  const LineEvent(this.line);

  final int line;

  @override
  List<Object?> get props => [line];
}

class StartLineEvent extends StatsEvent {
  const StartLineEvent(this.startLine);

  final int startLine;

  @override
  List<Object?> get props => [startLine];
}

class LevelEvent extends StatsEvent {
  const LevelEvent(this.level);

  final int level;

  @override
  List<Object?> get props => [level];
}

class Next extends StatsEvent {
  const Next(this.next);

  final BlockUnit next;

  @override
  List<Object?> get props => [next];
}

class Drop extends StatsEvent {
  const Drop();

  @override
  List<Object?> get props => [];
}

class DropShake extends StatsEvent {
  const DropShake();

  @override
  List<Object?> get props => [];
}

class Rotation extends StatsEvent {
  const Rotation();

  @override
  List<Object?> get props => [];
}

class Down extends StatsEvent {
  const Down();

  @override
  List<Object?> get props => [];
}

class Left extends StatsEvent {
  const Left();

  @override
  List<Object?> get props => [];
}

class Right extends StatsEvent {
  const Right();

  @override
  List<Object?> get props => [];
}

class LevelIncrease extends StatsEvent {
  const LevelIncrease();

  @override
  List<Object?> get props => [];
}

class LevelDecrease extends StatsEvent {
  const LevelDecrease();

  @override
  List<Object?> get props => [];
}

class StartLineIncrease extends StatsEvent {
  const StartLineIncrease();

  @override
  List<Object?> get props => [];
}

class StartLineDecrease extends StatsEvent {
  const StartLineDecrease();

  @override
  List<Object?> get props => [];
}
