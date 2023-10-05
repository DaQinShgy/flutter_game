import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_event.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/constants/strings.dart';
import 'package:flutter_game/tetris/objects/black_block.dart';
import 'package:flutter_game/tetris/objects/block_unit.dart';
import 'package:flutter_game/tetris/objects/icon_digital_bg.dart';
import 'package:flutter_game/tetris/objects/icon_number.dart';
import 'package:flutter_game/tetris/objects/icon_pause.dart';
import 'package:flutter_game/tetris/objects/icon_time.dart';
import 'package:flutter_game/tetris/objects/icon_trumpet.dart';

class AreaData extends PositionComponent with FlameBlocListenable<StatsBloc, StatsState> {
  AreaData({super.position, super.size});

  late TextComponent highestScore;

  late TextComponent currentScore;

  late TextComponent startLine;

  late TextComponent cleanLine;

  late TextComponent level;

  late TextComponent next;

  late IconNumber scoreIcon;

  late IconNumber lineIcon;

  late IconNumber levelIcon;

  @override
  FutureOr<void> onLoad() {
    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: Dimension.dataTextSize,
      ),
    );
    highestScore = TextComponent(
      text: Strings.highestScore,
      textRenderer: textPaint,
    );
    currentScore = TextComponent(
      text: Strings.score,
      textRenderer: textPaint,
    );
    startLine = TextComponent(
      text: Strings.startLine,
      position: Vector2(0, 50),
      textRenderer: textPaint,
    );
    cleanLine = TextComponent(
      text: Strings.cleanLine,
      position: Vector2(0, 50),
      textRenderer: textPaint,
    );
    level = TextComponent(
      text: Strings.level,
      position: Vector2(0, 100),
      textRenderer: textPaint,
    );
    next = TextComponent(
      text: Strings.next,
      position: Vector2(0, 150),
      textRenderer: textPaint,
    );
    addAll([highestScore, startLine, level, next]);

    addAll([
      IconDigitalBg(position: Vector2(size.x - 6 * 10, 20)),
      IconDigitalBg(position: Vector2(size.x - 6 * 10, 70)),
      IconDigitalBg(position: Vector2(size.x - 6 * 10, 120)),
    ]);

    List<BlackBlock> blackBlocks = [];
    for (int i = 0; i < 2; i++) {
      for (int j = 1; j <= 4; j++) {
        blackBlocks.add(
          BlackBlock(
            position: Vector2(
              size.x - j * Dimension.blackBlockSize,
              170 + i * Dimension.blackBlockSize,
            ),
            status: BlackBlockStatus.grey,
          ),
        );
      }
    }
    addAll(blackBlocks);

    addAll([
      IconTrumpet(position: Vector2(0, size.y - 15)),
      IconPause(position: Vector2(20, size.y - 15)),
      IconTime(position: Vector2(size.x - 40, size.y - 15)),
    ]);
  }

  @override
  bool listenWhen(StatsState previousState, StatsState newState) {
    if (previousState.status == GameStatus.mixing && newState.status == GameStatus.initial) {
      removeAll([currentScore, cleanLine]);
      addAll([highestScore, startLine]);
    } else if (previousState.status == GameStatus.initial && newState.status == GameStatus.running) {
      removeAll([highestScore, startLine]);
      addAll([
        currentScore,
        cleanLine,
        IconNumber(number: '0', position: Vector2(size.x - 10, 20)),
      ]);
    }
    return super.listenWhen(previousState, newState);
  }

  List<BlackBlock> blockUnit = [];

  bool firstUpdate = true;

  @override
  void update(double dt) {
    if (firstUpdate) {
      firstUpdate = false;
      scoreIcon = IconNumber(
        number: bloc.state.score.toString(),
        position: Vector2(size.x - 10, 20),
      );
      lineIcon = IconNumber(
        number: bloc.state.startLine.toString(),
        position: Vector2(size.x - 10, 70),
      );
      levelIcon = IconNumber(
        number: bloc.state.level.toString(),
        position: Vector2(size.x - 10, 120),
      );
      addAll([scoreIcon, lineIcon, levelIcon]);
      buildNext(bloc.state.next);
      bloc.on<Next>((event, emit) {
        emit(bloc.state.copyWith(next: event.next));
        removeAll(blockUnit);
        buildNext(event.next);
      });
      bloc.on<ScoreEvent>((event, emit) {
        emit(bloc.state.copyWith(score: bloc.state.score + event.score));
        scoreIcon.updateNumber(bloc.state.score.toString());
      });
      bloc.on<LineEvent>((event, emit) {
        emit(bloc.state.copyWith(cleanLine: bloc.state.cleanLine + event.line));
        debugPrint('line:${bloc.state.cleanLine.toString()}');
        lineIcon.updateNumber(bloc.state.cleanLine.toString());
      });
      bloc.on<LevelEvent>((event, emit) {
        emit(bloc.state.copyWith(level: event.level));
        levelIcon.updateNumber(bloc.state.level.toString());
      });
    }
  }

  void buildNext(BlockUnit unit) {
    blockUnit.clear();
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 4; j++) {
        if (unit.getForBg(j, i) == 1) {
          blockUnit.add(
            BlackBlock(
              position: Vector2(
                size.x - (unit.type == BlockUnitType.O ? 3 - j : 4 - j) * Dimension.blackBlockSize,
                170 + (unit.type == BlockUnitType.I ? i + 1 : i) * Dimension.blackBlockSize,
              ),
            ),
          );
        }
      }
    }
    addAll(blockUnit);
  }
}
