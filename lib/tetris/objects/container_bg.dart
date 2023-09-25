import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/colors_value.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/objects/area_control.dart';
import 'package:flutter_game/tetris/objects/area_data.dart';
import 'package:flutter_game/tetris/objects/area_game.dart';
import 'package:flutter_game/tetris/objects/black_block.dart';
import 'package:flutter_game/tetris/objects/block_unit.dart';

class ContainerBg extends CustomPainterComponent {
  ContainerBg({super.size});

  @override
  FutureOr<void> onLoad() async {
    painter = ContainerBgPainter();

    const borderLeft =
        (Dimension.containerMaxWidth - Dimension.screenMaxWidth) / 2 -
            Dimension.screenBorderMargin;
    const topMargin = Dimension.screenMaginTop -
        Dimension.screenBorderMargin +
        Dimension.blackBlockSize;
    List<BlackBlock> blackBlocks = [];
    // left blocks
    List<BlockUnit> leftBlockUnits = [
      BlockUnit.fromTypeRotate(BlockUnitType.Z, 90),
      BlockUnit.fromTypeRotate(BlockUnitType.T, 90),
      BlockUnit.fromTypeRotate(BlockUnitType.O, 0),
      BlockUnit.fromTypeRotate(BlockUnitType.T, 270),
      BlockUnit.fromTypeRotate(BlockUnitType.L, 270),
      BlockUnit.fromTypeRotate(BlockUnitType.I, 90),
    ];
    // right blocks
    List<BlockUnit> rightBlockUnits = [
      BlockUnit.fromTypeRotate(BlockUnitType.S, 90),
      BlockUnit.fromTypeRotate(BlockUnitType.T, 270),
      BlockUnit.fromTypeRotate(BlockUnitType.O, 0),
      BlockUnit.fromTypeRotate(BlockUnitType.T, 90),
      BlockUnit.fromTypeRotate(BlockUnitType.J, 90),
      BlockUnit.fromTypeRotate(BlockUnitType.I, 90),
    ];
    double leftX = (borderLeft - Dimension.blackBlockSize * 2) / 2;
    double rightX = borderLeft +
        Dimension.screenBorderMargin * 2 +
        Dimension.screenMaxWidth +
        (borderLeft - Dimension.blackBlockSize * 2) / 2;
    for (int i = 0; i < leftBlockUnits.length; i++) {
      BlockUnit leftBlockUnit = leftBlockUnits[i];
      BlockUnit rightBlockUnit = rightBlockUnits[i];
      double topPadding = (i == 0
              ? 0
              : i == 1
                  ? Dimension.blackBlockSize * 4
                  : i == 2
                      ? Dimension.blackBlockSize * 8
                      : i == 3
                          ? Dimension.blackBlockSize * 11
                          : i == 4
                              ? Dimension.blackBlockSize * 15
                              : Dimension.blackBlockSize * 19) *
          1.07;
      for (int j = 0; j < leftBlockUnit.shape.length; j++) {
        if (leftBlockUnit.getForBg(0, j) == 1) {
          blackBlocks.add(
            BlackBlock(
              position: Vector2(
                leftX,
                topMargin + topPadding + j * Dimension.blackBlockSize,
              ),
            ),
          );
        }
        if (leftBlockUnit.getForBg(1, j) == 1) {
          blackBlocks.add(
            BlackBlock(
              position: Vector2(
                leftX + Dimension.blackBlockSize,
                topMargin + topPadding + j * Dimension.blackBlockSize,
              ),
            ),
          );
        }
        if (rightBlockUnit.getForBg(0, j) == 1) {
          blackBlocks.add(
            BlackBlock(
              position: Vector2(
                rightX + (i == 5 ? Dimension.blackBlockSize : 0),
                topMargin + topPadding + j * Dimension.blackBlockSize,
              ),
            ),
          );
        }
        if (rightBlockUnit.getForBg(1, j) == 1) {
          blackBlocks.add(
            BlackBlock(
              position: Vector2(
                rightX + Dimension.blackBlockSize,
                topMargin + topPadding + j * Dimension.blackBlockSize,
              ),
            ),
          );
        }
      }
    }
    double gameMargin = (Dimension.screenMaxHeight -
            Dimension.blackBlockSize * Dimension.blackBlockRow) /
        2;
    addAll([
      ...blackBlocks,
      AreaGame(
        position: Vector2(
          (Dimension.containerMaxWidth - Dimension.screenMaxWidth) / 2 +
              gameMargin,
          Dimension.screenMaginTop + gameMargin,
        ),
      ),
      AreaData(
        position: Vector2(
          borderLeft +
              Dimension.screenBorderMargin +
              gameMargin +
              Dimension.blackBlockSize * Dimension.blackBlockColumn +
              Dimension.blackBlockPadding * 2 +
              Dimension.dataMargin,
          Dimension.screenMaginTop + gameMargin,
        ),
        size: Vector2(
          Dimension.screenMaxWidth -
              gameMargin -
              Dimension.blackBlockSize * Dimension.blackBlockColumn -
              Dimension.blackBlockPadding * 4 -
              Dimension.dataMargin * 1.5,
          Dimension.screenMaxHeight - gameMargin * 2,
        ),
      ),
      AreaControl(
        position: Vector2(
          Dimension.controlHorizationMargin,
          Dimension.screenMaginTop +
              Dimension.screenMaxHeight +
              Dimension.screenBorderMargin +
              Dimension.screenBorderWidth,
        ),
        size: Vector2(
          Dimension.containerMaxWidth - Dimension.controlHorizationMargin * 2,
          size.y -
              Dimension.screenMaxHeight -
              Dimension.screenBorderMargin -
              Dimension.screenMaginTop,
        ),
      ),
    ]);
  }
}

class ContainerBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(15.0),
      ),
      const PaletteEntry(Color(ColorsValue.containerBg)).paint(),
    );

    const screenLeft =
        (Dimension.containerMaxWidth - Dimension.screenMaxWidth) / 2;
    // screen background
    canvas.drawRect(
      const Rect.fromLTWH(
        screenLeft,
        Dimension.screenMaginTop,
        Dimension.screenMaxWidth,
        Dimension.screenMaxHeight,
      ),
      const PaletteEntry(Color(ColorsValue.screenBg)).paint(),
    );
    // screen shadow
    Paint screenShadowPaint = Paint();
    screenShadowPaint.color = const Color(ColorsValue.screenShadow);
    screenShadowPaint.strokeWidth = Dimension.screenShadowWidth;
    canvas.drawLine(
      const Offset(screenLeft - Dimension.screenShadowWidth,
          Dimension.screenMaginTop - Dimension.screenShadowWidth / 2),
      const Offset(
        screenLeft + Dimension.screenMaxWidth + Dimension.screenShadowWidth,
        Dimension.screenMaginTop - Dimension.screenShadowWidth / 2,
      ),
      screenShadowPaint,
    );
    canvas.drawLine(
      const Offset(screenLeft - Dimension.screenShadowWidth / 2,
          Dimension.screenMaginTop),
      const Offset(screenLeft - Dimension.screenShadowWidth / 2,
          Dimension.screenMaginTop + Dimension.screenMaxHeight),
      screenShadowPaint,
    );
    canvas.drawLine(
      const Offset(
        screenLeft - Dimension.screenShadowWidth,
        Dimension.screenMaginTop +
            Dimension.screenMaxHeight +
            Dimension.screenShadowWidth / 2,
      ),
      const Offset(
        screenLeft + Dimension.screenMaxWidth + Dimension.screenShadowWidth,
        Dimension.screenMaginTop +
            Dimension.screenMaxHeight +
            Dimension.screenShadowWidth / 2,
      ),
      screenShadowPaint,
    );
    canvas.drawLine(
      const Offset(
        screenLeft + Dimension.screenMaxWidth + Dimension.screenShadowWidth / 2,
        Dimension.screenMaginTop,
      ),
      const Offset(
        screenLeft + Dimension.screenMaxWidth + Dimension.screenShadowWidth / 2,
        Dimension.screenMaginTop + Dimension.screenMaxHeight,
      ),
      screenShadowPaint,
    );
    // screen inner border
    Paint innerBorderPaint = Paint();
    innerBorderPaint.style = PaintingStyle.stroke;
    innerBorderPaint.color = Colors.black;
    canvas.drawRect(
      const Rect.fromLTWH(
        screenLeft,
        Dimension.screenMaginTop,
        Dimension.screenMaxWidth,
        Dimension.screenMaxHeight,
      ),
      innerBorderPaint,
    );

    // left border of screen
    canvas.drawRect(
      const Rect.fromLTWH(
        screenLeft - Dimension.screenBorderMargin,
        Dimension.screenMaginTop - Dimension.screenBorderMargin,
        Dimension.screenBorderWidth,
        Dimension.screenMaxHeight + Dimension.screenBorderMargin * 2,
      ),
      BasicPalette.black.paint(),
    );
    // right border of screen
    canvas.drawRect(
      const Rect.fromLTWH(
        screenLeft +
            Dimension.screenMaxWidth +
            Dimension.screenBorderMargin -
            Dimension.screenBorderWidth,
        Dimension.screenMaginTop - Dimension.screenBorderMargin,
        Dimension.screenBorderWidth,
        Dimension.screenMaxHeight + Dimension.screenBorderMargin * 2,
      ),
      BasicPalette.black.paint(),
    );
    // bottom border of screen
    canvas.drawRect(
      const Rect.fromLTWH(
        screenLeft - Dimension.screenBorderMargin,
        Dimension.screenMaginTop +
            Dimension.screenMaxHeight +
            Dimension.screenBorderMargin,
        Dimension.screenMaxWidth + Dimension.screenBorderMargin * 2,
        Dimension.screenBorderWidth,
      ),
      BasicPalette.black.paint(),
    );
    // top border of screen
    canvas.drawRect(
      const Rect.fromLTWH(
        screenLeft - Dimension.screenBorderMargin,
        Dimension.screenMaginTop -
            Dimension.screenBorderMargin -
            Dimension.screenBorderWidth,
        Dimension.screenBorderMargin,
        Dimension.screenBorderWidth,
      ),
      BasicPalette.black.paint(),
    );
    canvas.drawRect(
      const Rect.fromLTWH(
        screenLeft + Dimension.screenMaxWidth,
        Dimension.screenMaginTop -
            Dimension.screenBorderMargin -
            Dimension.screenBorderWidth,
        Dimension.screenBorderMargin,
        Dimension.screenBorderWidth,
      ),
      BasicPalette.black.paint(),
    );
    // top-left point border
    for (var i = 1; i <= 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          screenLeft +
              Dimension.screenBorderWidth * 2 * i -
              Dimension.screenBorderWidth,
          Dimension.screenMaginTop -
              Dimension.screenBorderMargin -
              Dimension.screenBorderWidth,
          Dimension.screenBorderWidth,
          Dimension.screenBorderWidth,
        ),
        BasicPalette.black.paint(),
      );
    }
    // top-right point border
    for (var i = 1; i <= 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          screenLeft +
              Dimension.screenMaxWidth -
              Dimension.screenBorderWidth * 2 * i,
          Dimension.screenMaginTop -
              Dimension.screenBorderMargin -
              Dimension.screenBorderWidth,
          Dimension.screenBorderWidth,
          Dimension.screenBorderWidth,
        ),
        BasicPalette.black.paint(),
      );
    }

    // game border
    double borderMargin = (Dimension.screenMaxHeight -
            Dimension.blackBlockSize * Dimension.blackBlockRow -
            Dimension.blackBlockPadding * 4) /
        2;
    Paint gameBorderPaint = Paint();
    gameBorderPaint.style = PaintingStyle.stroke;
    gameBorderPaint.strokeWidth = 1;
    gameBorderPaint.color = Colors.black;
    canvas.drawRect(
      Rect.fromLTWH(
        screenLeft + borderMargin,
        Dimension.screenMaginTop + borderMargin,
        Dimension.blackBlockSize * Dimension.blackBlockColumn +
            Dimension.blackBlockPadding * 4,
        Dimension.blackBlockSize * Dimension.blackBlockRow +
            Dimension.blackBlockPadding * 4,
      ),
      gameBorderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
