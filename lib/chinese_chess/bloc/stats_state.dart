import 'package:equatable/equatable.dart';

enum GameStatus {
  reset,
  initial,
  running,
  pause,
}

class StatsState extends Equatable {
  final GameStatus status;
  final int step;
  final int level;
  final bool first;

  const StatsState({
    required this.status,
    required this.step,
    required this.level,
    required this.first,
  });

  const StatsState.empty()
      : this(
          status: GameStatus.initial,
          step: 0,
          level: 1,
          first: true,
        );

  StatsState copyWith({
    GameStatus? status,
    int? step,
    int? level,
    bool? first,
  }) {
    return StatsState(
      status: status ?? this.status,
      step: step ?? this.step,
      level: level ?? this.level,
      first: first ?? this.first,
    );
  }

  @override
  List<Object?> get props => [
        status,
        step,
        level,
        first,
      ];
}
