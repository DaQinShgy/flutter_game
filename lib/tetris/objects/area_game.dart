import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/objects/black_block.dart';

import '../constants/strings.dart';
import 'icon_dragon.dart';

class AreaGame extends PositionComponent {
  AreaGame({super.position})
      : super(
          size: Vector2(
            Dimension.blackBlockSize * Dimension.blackBlockColumn,
            Dimension.blackBlockSize * Dimension.blackBlockRow,
          ),
        );

  final List<BlackBlock> _list = [];

  @override
  FutureOr<void> onLoad() {
    for (int i = 0; i < Dimension.blackBlockColumn; i++) {
      for (int j = 0; j < Dimension.blackBlockRow; j++) {
        BlackBlock blackBlock = BlackBlock(
          position: Vector2(
            i * Dimension.blackBlockSize,
            j * Dimension.blackBlockSize,
          ),
          status: BlackBlockStatus.grey,
        );
        _list.add(blackBlock);
      }
    }
    addAll(_list);
    reset();
  }

  reset() async {
    List<List<BlackBlock>> initList = [];
    for (int i = Dimension.blackBlockRow - 1; i >= 0; i--) {
      List<BlackBlock> rowList = [];
      for (int j = Dimension.blackBlockColumn - 1; j >= 0; j--) {
        BlackBlock blackBlock = BlackBlock(
          position: Vector2(
            j * Dimension.blackBlockSize,
            i * Dimension.blackBlockSize,
          ),
          status: BlackBlockStatus.black,
        );
        rowList.add(blackBlock);
      }
      initList.add(rowList);
    }
    for (final element in initList) {
      addAll(element);
      await Future.delayed(const Duration(milliseconds: 50));
    }
    for (final element in initList.reversed) {
      removeAll(element);
      await Future.delayed(const Duration(milliseconds: 50));
    }
    final textAppName = TextComponent(
      position: Vector2(size.x / 2, Dimension.blackBlockSize * 9),
      anchor: Anchor.topCenter,
      text: Strings.appName,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          letterSpacing: 4,
        ),
      ),
    );
    final components = [
      IconDragon(
        position: Vector2(
          Dimension.blackBlockSize * 3,
          Dimension.blackBlockSize * 4,
        ),
        size: Vector2(
          Dimension.blackBlockSize * 4,
          Dimension.blackBlockSize * 4,
        ),
      ),
      textAppName,
    ];
    addAll(components);
    for (int i = 0; i < 2; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      for (var element in components) {
        element.scale = Vector2(0, 0);
      }
      await Future.delayed(const Duration(milliseconds: 70));
      for (var element in components) {
        element.scale = Vector2(1, 1);
      }
    }
  }
}
