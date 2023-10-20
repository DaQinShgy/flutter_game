import 'package:equatable/equatable.dart';

enum GameStatus {
  initial,
  running,
  pause,
  over,
}

class StatsState extends Equatable {
  final GameStatus status;
  final int coinScore;

  const StatsState({
    required this.status,
    required this.coinScore,
  });

  const StatsState.empty()
      : this(
          status: GameStatus.initial,
          coinScore: 0,
        );

  StatsState copyWith({
    GameStatus? status,
    int? coinScore,
  }) {
    return StatsState(
      status: status ?? this.status,
      coinScore: coinScore ?? this.coinScore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        coinScore,
      ];
}
