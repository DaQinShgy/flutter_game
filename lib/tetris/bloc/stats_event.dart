import 'package:equatable/equatable.dart';
import 'package:flutter_game/tetris/objects/block_unit.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
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

class ScoreEvent extends StatsEvent {
  const ScoreEvent(this.score);

  final int score;

  @override
  List<Object?> get props => [score];
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
