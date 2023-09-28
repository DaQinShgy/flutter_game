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
import 'package:flutter_game/tetris/objects/icon_dragon.dart';
import 'package:flutter_game/tetris/teris_game.dart';

class AreaGame extends PositionComponent
    with HasGameRef<TerisGame>, FlameBlocListenable<StatsBloc, StatsState> {
  AreaGame({super.position})
      : super(
          size: Vector2(
            Dimension.blackBlockSize * Dimension.blackBlockColumn,
            Dimension.blackBlockSize * Dimension.blackBlockRow,
          ),
        );

  /// Game backgound of grey block
  final List<BlackBlock> _list = [];

  /// Init components, includs dragon icon and tetris text
  List<PositionComponent> _initComponents = [];

  double speed = 1;

  double _currentTimer = 0;

  /// Current blockUnit
  BlockUnit? _current;

  /// Game blackBlock data
  final List<List<int>> _data = List.generate(
    Dimension.blackBlockRow,
    (index) => List.generate(Dimension.blackBlockColumn, (index1) => 0),
  );

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
  }

  @override
  void onInitialState(StatsState state) {
    if (state.status == GameStatus.initial) {
      reset();
    }
  }

  @override
  void onNewState(StatsState state) {
    if (state.status == GameStatus.initial) {
      reset();
    }
  }

  @override
  bool listenWhen(StatsState previousState, StatsState newState) {
    if (newState.status == GameStatus.running) {
      if (_current == null) {
        _current = newState.next;
        // Create next blockUnit
        bloc.add(Next(BlockUnit.getRandom()));
      }
      if (previousState.status == GameStatus.initial) {
        removeAll(_initComponents);
        buildData();
      } else {}
    }
    return super.listenWhen(previousState, newState);
  }

  bool firstUpdate = true;

  @override
  void update(double dt) {
    if (firstUpdate) {
      firstUpdate = false;
      bloc.on<Drop>((event, emit) {
        for (int j = 0; j < Dimension.blackBlockRow; j++) {
          BlockUnit? fallBlock = _current?.fall(step: j + 1);
          if (fallBlock != null && !fallBlock.isValidInMatrix(_data)) {
            _current = _current?.fall(step: j);
            buildData();
            break;
          }
        }
      });
      bloc.on<Rotation>((event, emit) {
        BlockUnit? blockUnit = _current?.rotate();
        if (blockUnit != null && blockUnit.isValidInMatrix(_data)) {
          _current = blockUnit;
          buildData();
        }
      });
      bloc.on<Down>((event, emit) {
        BlockUnit? blockUnit = _current?.fall();
        if (blockUnit != null && blockUnit.isValidInMatrix(_data)) {
          _current = blockUnit;
          buildData();
        }
      });
      bloc.on<Left>((event, emit) {
        BlockUnit? blockUnit = _current?.left();
        if (blockUnit != null && blockUnit.isValidInMatrix(_data)) {
          _current = blockUnit;
          buildData();
        }
      });
      bloc.on<Right>((event, emit) {
        BlockUnit? blockUnit = _current?.right();
        if (blockUnit != null && blockUnit.isValidInMatrix(_data)) {
          _current = blockUnit;
          buildData();
        }
      });
    }
    if (bloc.state.status == GameStatus.running) {
      _currentTimer += dt;
      if (_currentTimer >= speed) {
        while (_currentTimer >= speed) {
          _currentTimer -= speed;
        }
      } else {
        return;
      }
      BlockUnit? fallBlock = _current?.fall();
      if (fallBlock != null && fallBlock.isValidInMatrix(_data)) {
        _current = fallBlock;
      } else {
        _current = bloc.state.next;
        // Create next blockUnit
        bloc.add(Next(BlockUnit.getRandom()));
      }
      buildData();
    }
  }

  /// init game
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
    if (_initComponents.isEmpty) {
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
      _initComponents = [
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
    }
    addAll(_initComponents);
    for (int i = 0; i < 2; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      for (var element in _initComponents) {
        element.scale = Vector2(0, 0);
      }
      await Future.delayed(const Duration(milliseconds: 70));
      for (var element in _initComponents) {
        element.scale = Vector2(1, 1);
      }
    }
  }

  /// black block list
  final List<BlackBlock> _mixed = [];

  /// bulid game data
  void buildData({bool ignoreHitBottom = false}) async {
    removeAll(_mixed);
    _mixed.clear();
    bool hitBottom = false;
    if (!ignoreHitBottom) {
      BlockUnit? fallBlock = _current?.fall();
      if (fallBlock != null && !fallBlock.isValidInMatrix(_data)) {
        hitBottom = true;
      }
    }
    for (int i = 0; i < Dimension.blackBlockColumn; i++) {
      for (int j = 0; j < Dimension.blackBlockRow; j++) {
        int? valueCurrent = _current?.get(i, j);
        int value = valueCurrent ?? _data[j][i];
        if (value == 1) {
          BlackBlock blackBlock = BlackBlock(
            position: Vector2(
              i * Dimension.blackBlockSize,
              j * Dimension.blackBlockSize,
            ),
            status: hitBottom && valueCurrent == 1
                ? BlackBlockStatus.red
                : BlackBlockStatus.black,
          );
          _mixed.add(blackBlock);
        }
      }
    }
    if (hitBottom) {
      // Add hit bottom blockUnit to data
      for (int i = 0; i < _current!.shape.length; i++) {
        for (int j = 0; j < _current!.shape[i].length; j++) {
          if (_current!.shape[i][j] == 1) {
            _data[_current!.xy[1] + i][_current!.xy[0] + j] = 1;
          }
        }
      }
    }
    addAll(_mixed);
    if (hitBottom) {
      await Future.delayed(const Duration(milliseconds: 100));
      buildData(ignoreHitBottom: true);
    }
  }
}
