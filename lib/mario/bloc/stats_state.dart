import 'package:equatable/equatable.dart';

enum GameStatus {
  initial,
  running,
  pause,
  over,
  victory,
}

class StatsState extends Equatable {
  final GameStatus status;
  final int score;
  final int coin;
  final int time;
  final int lives;
  final int top;

  const StatsState({
    required this.status,
    required this.score,
    required this.coin,
    required this.time,
    required this.lives,
    required this.top,
  });

  const StatsState.empty()
      : this(
          status: GameStatus.initial,
          score: 0,
          coin: 0,
          lives: 3,
          time: 400,
          top: 0,
        );

  StatsState copyWith({
    GameStatus? status,
    int? score,
    int? coin,
    int? time,
    int? lives,
    int? top,
  }) {
    return StatsState(
      status: status ?? this.status,
      score: score ?? this.score,
      coin: coin ?? this.coin,
      time: time ?? this.time,
      lives: lives ?? this.lives,
      top: top ?? this.top,
    );
  }

  @override
  List<Object?> get props => [
        status,
        score,
        coin,
        time,
        lives,
        top,
      ];
}
