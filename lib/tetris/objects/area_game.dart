import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
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
import 'package:flutter_game/tetris/tetris_game.dart';

class AreaGame extends PositionComponent with HasGameRef<TetrisGame>, FlameBlocListenable<StatsBloc, StatsState> {
  AreaGame({super.position})
      : super(
          size: Vector2(
            Dimension.blackBlockSize * Dimension.blackBlockColumn,
            Dimension.blackBlockSize * Dimension.blackBlockRow,
          ),
        );

  /// Game background of grey block
  final List<BlackBlock> _list = [];

  /// Init components, includes dragon icon and tetris text
  List<PositionComponent> _initComponents = [];

  double speed = 1;

  final speedArr = [0.8, 0.65, 0.5, 0.37, 0.25, 0.16];

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
    if (state.status == GameStatus.reset) {
      reset();
    }
  }

  @override
  bool listenWhen(StatsState previousState, StatsState newState) {
    if (previousState.status == GameStatus.initial && newState.status == GameStatus.running) {
      removeAll(_initComponents);
      _initComponents.clear();
      if (bloc.state.startLine > 0) {
        for (int i = 0; i < Dimension.blackBlockColumn; i++) {
          for (int j = Dimension.blackBlockRow - 1; j >= Dimension.blackBlockRow - bloc.state.startLine; j--) {
            _data[j][i] = math.Random().nextInt(2);
          }
        }
        _buildData();
      }
      speed = speedArr[bloc.state.level - 1];
      if (!bloc.state.mute) {
        FlameAudio.play('tetris/start.mp3');
      }
    } else if (newState.status == GameStatus.reset) {
      reset();
      _current = null;
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
            _buildData();
            _mixCurrentIntoData();
            bloc.add(const DropShake());
            if (!bloc.state.mute) {
              FlameAudio.play('tetris/drop.mp3');
            }
            break;
          }
        }
      });
      bloc.on<Rotation>((event, emit) {
        BlockUnit? blockUnit = _current?.rotate();
        if (blockUnit != null && blockUnit.isValidInMatrix(_data)) {
          _current = blockUnit;
          _buildData();
          if (!bloc.state.mute) {
            FlameAudio.play('tetris/rotate.mp3');
          }
        }
      });
      bloc.on<Down>((event, emit) {
        BlockUnit? blockUnit = _current?.fall();
        if (blockUnit != null && blockUnit.isValidInMatrix(_data)) {
          _current = blockUnit;
          _buildData();
          if (!bloc.state.mute) {
            FlameAudio.play('tetris/move.mp3');
          }
        }
      });
      bloc.on<Left>((event, emit) {
        BlockUnit? blockUnit = _current?.left();
        if (blockUnit != null && blockUnit.isValidInMatrix(_data)) {
          _current = blockUnit;
          _buildData();
          if (!bloc.state.mute) {
            FlameAudio.play('tetris/move.mp3');
          }
        }
      });
      bloc.on<Right>((event, emit) {
        BlockUnit? blockUnit = _current?.right();
        if (blockUnit != null && blockUnit.isValidInMatrix(_data)) {
          _current = blockUnit;
          _buildData();
          if (!bloc.state.mute) {
            FlameAudio.play('tetris/move.mp3');
          }
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
      if (_current == null) {
        _current = bloc.state.next;
        // Create next blockUnit
        bloc.add(Next(BlockUnit.getRandom()));
        _buildData();
      } else {
        BlockUnit? fallBlock = _current?.fall();
        if (fallBlock != null && fallBlock.isValidInMatrix(_data)) {
          _current = fallBlock;
          _buildData();
        } else {
          _buildData();
          _mixCurrentIntoData();
        }
      }
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
      await Future.delayed(const Duration(milliseconds: 30));
    }
    if (_mixed.isNotEmpty) {
      removeAll(_mixed);
      _mixed.clear();
      for (int i = 0; i < Dimension.blackBlockColumn; i++) {
        for (int j = 0; j < Dimension.blackBlockRow; j++) {
          _data[j][i] = 0;
        }
      }
    }
    for (final element in initList.reversed) {
      removeAll(element);
      await Future.delayed(const Duration(milliseconds: 30));
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
    bloc.add(const GameInitial());
  }

  /// black block list
  final List<BlackBlock> _mixed = [];

  /// build game data
  void _buildData() {
    removeAll(_mixed);
    _mixed.clear();
    for (int i = 0; i < Dimension.blackBlockColumn; i++) {
      for (int j = 0; j < Dimension.blackBlockRow; j++) {
        int value = _current?.get(i, j) ?? _data[j][i];
        if (value == 1) {
          BlackBlock blackBlock = BlackBlock(
            position: Vector2(
              i * Dimension.blackBlockSize,
              j * Dimension.blackBlockSize,
            ),
          );
          _mixed.add(blackBlock);
        }
      }
    }
    addAll(_mixed);
  }

  Future<void> _mixCurrentIntoData({VoidCallback? mixSound}) async {
    if (_current == null) {
      return;
    }
    bloc.add(const GameMixing());
    // Add hit bottom blockUnit to data
    for (int i = 0; i < _current!.shape.length; i++) {
      for (int j = 0; j < _current!.shape[i].length; j++) {
        if (_current!.shape[i][j] == 1 && _current!.xy[1] + i >= 0 && _current!.xy[0] + j >= 0) {
          _data[_current!.xy[1] + i][_current!.xy[0] + j] = 1;
        }
      }
    }
    final clearLines = [];
    for (int i = 0; i < _data.length; i++) {
      if (_data[i].every((d) => d == 1)) {
        clearLines.add(i);
      }
    }
    if (clearLines.isEmpty) {
      List<BlackBlock> mask = [];
      for (int i = 0; i < Dimension.blackBlockColumn; i++) {
        for (int j = 0; j < Dimension.blackBlockRow; j++) {
          if (_current?.get(i, j) == 1) {
            BlackBlock blackBlock = BlackBlock(
              position: Vector2(
                i * Dimension.blackBlockSize,
                j * Dimension.blackBlockSize,
              ),
              status: BlackBlockStatus.red,
            );
            mask.add(blackBlock);
          }
        }
      }
      addAll(mask);
      await Future.delayed(const Duration(milliseconds: 100));
      removeAll(mask);
    } else {
      if (!bloc.state.mute) {
        FlameAudio.play('tetris/clean.mp3');
      }
      List<BlackBlock> mask = [];
      for (var i in clearLines) {
        for (int j = 0; j < Dimension.blackBlockColumn; j++) {
          BlackBlock blackBlock = BlackBlock(
            position: Vector2(
              j * Dimension.blackBlockSize,
              i * Dimension.blackBlockSize,
            ),
            status: BlackBlockStatus.red,
          );
          mask.add(blackBlock);
        }
      }
      for (int i = 0; i < 6; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (i % 2 == 0) {
          addAll(mask);
        } else {
          removeAll(mask);
        }
      }
      // Remove clearLines of data
      for (var line in clearLines) {
        _data.setRange(1, line + 1, _data);
        _data[0] = List.filled(Dimension.blackBlockColumn, 0);
      }
      // bloc event
      bloc.add(LineEvent(clearLines.length));
      //1: 	100 × level
      //2: 	300 × level
      //3: 	500 × level
      //4: 	800 × level
      bloc.add(ScoreEvent(bloc.state.level *
          (clearLines.length == 1
              ? 100
              : clearLines.length == 2
                  ? 300
                  : clearLines.length == 3
                      ? 500
                      : 800)));
      //up level possible when cleared
      int level = (bloc.state.cleanLine ~/ 50) + 1;
      if (level <= 6 && level > bloc.state.level) {
        bloc.add(LevelEvent(level));
        speed = speedArr[level - 1];
      }
    }

    _current = null;
    // Refresh data
    _buildData();

    if (_data[0].contains(1)) {
      bloc.add(const GameReset());
      if (!bloc.state.mute) {
        FlameAudio.play('tetris/explosion.mp3');
      }
    } else {
      bloc.add(const GameRunning());
    }
  }
}
