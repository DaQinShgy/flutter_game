import 'package:equatable/equatable.dart';

enum GameStatus {
  initial,
  running,
  dying,
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
  final bool fastCountDown;
  final bool finish;

  const StatsState({
    required this.status,
    required this.score,
    required this.coin,
    required this.time,
    required this.lives,
    required this.top,
    required this.fastCountDown,
    required this.finish,
  });

  const StatsState.empty()
      : this(
          status: GameStatus.initial,
          score: 0,
          coin: 0,
          lives: 3,
          time: 400,
          top: 0,
          fastCountDown: false,
          finish: false,
        );

  StatsState copyWith({
    GameStatus? status,
    int? score,
    int? coin,
    int? time,
    int? lives,
    int? top,
    bool? fastCountDown,
    bool? finish,
  }) {
    return StatsState(
      status: status ?? this.status,
      score: score ?? this.score,
      coin: coin ?? this.coin,
      time: time ?? this.time,
      lives: lives ?? this.lives,
      top: top ?? this.top,
      fastCountDown: fastCountDown ?? this.fastCountDown,
      finish: finish ?? this.finish,
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
        fastCountDown,
        finish,
      ];
}
