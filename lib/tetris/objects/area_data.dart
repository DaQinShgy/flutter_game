import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/constants/strings.dart';
import 'package:flutter_game/tetris/objects/black_block.dart';
import 'package:flutter_game/tetris/objects/icon_digital_bg.dart';
import 'package:flutter_game/tetris/objects/icon_pause.dart';
import 'package:flutter_game/tetris/objects/icon_time.dart';
import 'package:flutter_game/tetris/objects/icon_trumpet.dart';

class AreaData extends PositionComponent {
  AreaData({super.position, super.size});

  late TextComponent highestScore;

  late TextComponent lastScore;

  late TextComponent startLine;

  late TextComponent level;

  late TextComponent next;

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
    lastScore = TextComponent(
      text: Strings.lastScore,
      textRenderer: textPaint,
    );
    startLine = TextComponent(
      text: Strings.startLine,
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
}
