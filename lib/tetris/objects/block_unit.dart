import 'dart:math' as math;

import 'package:flutter_game/tetris/constants/dimension.dart';

const blockUnitShapes = {
  BlockUnitType.I: [
    [1, 1, 1, 1]
  ],
  BlockUnitType.L: [
    [0, 0, 1],
    [1, 1, 1],
  ],
  BlockUnitType.J: [
    [1, 0, 0],
    [1, 1, 1],
  ],
  BlockUnitType.Z: [
    [1, 1, 0],
    [0, 1, 1],
  ],
  BlockUnitType.S: [
    [0, 1, 1],
    [1, 1, 0],
  ],
  BlockUnitType.O: [
    [1, 1],
    [1, 1]
  ],
  BlockUnitType.T: [
    [0, 1, 0],
    [1, 1, 1]
  ]
};

///方块初始化时的位置
const startXy = {
  BlockUnitType.I: [3, 0],
  BlockUnitType.L: [4, -1],
  BlockUnitType.J: [4, -1],
  BlockUnitType.Z: [4, -1],
  BlockUnitType.S: [4, -1],
  BlockUnitType.O: [4, -1],
  BlockUnitType.T: [4, -1],
};

///方块变换时的中心点
const origin = {
  BlockUnitType.I: [
    [1, -1],
    [-1, 1],
  ],
  BlockUnitType.L: [
    [0, 0]
  ],
  BlockUnitType.J: [
    [0, 0]
  ],
  BlockUnitType.Z: [
    [0, 0]
  ],
  BlockUnitType.S: [
    [0, 0]
  ],
  BlockUnitType.O: [
    [0, 0]
  ],
  BlockUnitType.T: [
    [0, 0],
    [0, 1],
    [1, -1],
    [-1, 0]
  ],
};

enum BlockUnitType { I, L, J, Z, S, O, T }

class BlockUnit {
  final BlockUnitType type;
  final List<List<int>> shape;
  final List<int> xy;
  final int rotateIndex;

  BlockUnit(this.type, this.shape, this.xy, this.rotateIndex);

  BlockUnit fall({int step = 1}) {
    return BlockUnit(type, shape, [xy[0], xy[1] + step], rotateIndex);
  }

  BlockUnit right() {
    return BlockUnit(type, shape, [xy[0] + 1, xy[1]], rotateIndex);
  }

  BlockUnit left() {
    return BlockUnit(type, shape, [xy[0] - 1, xy[1]], rotateIndex);
  }

  BlockUnit rotate() {
    List<List<int>> result =
        List.filled(shape[0].length, const [], growable: false);
    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (result[col].isEmpty) {
          result[col] = List.filled(shape.length, 0, growable: false);
        }
        result[col][row] = shape[shape.length - 1 - row][col];
      }
    }
    final nextXy = [
      xy[0] + origin[type]![rotateIndex][0],
      xy[1] + origin[type]![rotateIndex][1]
    ];
    final nextRotateIndex =
        rotateIndex + 1 >= origin[type]!.length ? 0 : rotateIndex + 1;
    return BlockUnit(type, result, nextXy, nextRotateIndex);
  }

  bool isValidInMatrix(List<List<int>> matrix) {
    if (xy[1] + shape.length > Dimension.blackBlockRow ||
        xy[0] < 0 ||
        xy[0] + shape[0].length > Dimension.blackBlockColumn) {
      return false;
    }
    for (var i = 0; i < matrix.length; i++) {
      final line = matrix[i];
      for (var j = 0; j < line.length; j++) {
        if (line[j] == 1 && get(j, i) == 1) {
          return false;
        }
      }
    }
    return true;
  }

  ///return null if do not show at [x][y]
  ///return 1 if show at [x,y]
  int? get(int x, int y) {
    x -= xy[0];
    y -= xy[1];
    if (x < 0 || x >= shape[0].length || y < 0 || y >= shape.length) {
      return null;
    }
    return shape[y][x] == 1 ? 1 : null;
  }

  int? getForBg(int x, int y) {
    //shape=[[0, 0, 1], [1, 1, 1]]
    if (x < 0 || x >= shape[0].length || y < 0 || y >= shape.length) {
      return null;
    }
    return shape[y][x] == 1 ? 1 : null;
  }

  static BlockUnit fromType(BlockUnitType type) {
    final shape = blockUnitShapes[type];
    return BlockUnit(type, shape!, startXy[type]!, 0);
  }

  static BlockUnit fromTypeRotate(BlockUnitType type, int rotateAngle) {
    final shape = blockUnitShapes[type];
    BlockUnit origin = BlockUnit(type, shape!, startXy[type]!, 0);
    if (rotateAngle == 0) {
      return origin;
    } else if (rotateAngle == 90) {
      return origin.rotate();
    } else if (rotateAngle == 180) {
      return origin.rotate().rotate();
    } else if (rotateAngle == 270) {
      return origin.rotate().rotate().rotate();
    }
    return origin;
  }

  static BlockUnit getRandom() {
    final i = math.Random().nextInt(BlockUnitType.values.length);
    return fromType(BlockUnitType.values[i]);
  }
}
