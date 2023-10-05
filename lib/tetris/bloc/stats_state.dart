import 'package:equatable/equatable.dart';
import 'package:flutter_game/tetris/objects/block_unit.dart';

enum GameStatus {
  reset,
  initial,
  running,
  pause,
  mixing,
}

class StatsState extends Equatable {
  final int score;
  final int maxScore;
  final int startLine;
  final int cleanLine;
  final int level;
  final GameStatus status;
  final BlockUnit next;
  final bool mute;

  const StatsState({
    required this.score,
    required this.maxScore,
    required this.startLine,
    required this.cleanLine,
    required this.level,
    required this.status,
    required this.next,
    required this.mute,
  });

  StatsState.empty()
      : this(
          score: 0,
          maxScore: 0,
          startLine: 0,
          cleanLine: 0,
          level: 1,
          status: GameStatus.reset,
          next: BlockUnit.getRandom(),
          mute: false,
        );

  StatsState copyWith({
    int? score,
    int? maxScore,
    int? startLine,
    int? cleanLine,
    int? level,
    GameStatus? status,
    BlockUnit? next,
    bool? mute,
  }) {
    return StatsState(
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      startLine: startLine ?? this.startLine,
      cleanLine: cleanLine ?? this.cleanLine,
      level: level ?? this.level,
      status: status ?? this.status,
      next: next ?? this.next,
      mute: mute ?? this.mute,
    );
  }

  @override
  List<Object?> get props => [
        score,
        maxScore,
        startLine,
        cleanLine,
        level,
        status,
        next,
        mute,
      ];
}
