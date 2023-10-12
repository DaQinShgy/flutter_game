import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/colors_value.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/constants/strings.dart';
import 'package:flutter_game/tetris/objects/area_data.dart';
import 'package:flutter_game/tetris/objects/area_game.dart';
import 'package:flutter_game/tetris/objects/black_block.dart';
import 'package:flutter_game/tetris/objects/block_unit.dart';

class ContainerComponent extends CustomPainterComponent {
  ContainerComponent({super.position, super.size});

  @override
  FutureOr<void> onLoad() async {
    painter = ContainerComponentPainter();

    double screenLeft = Dimension.containerMaxWidth * 0.4 / 2;
    double screenTop = (size.y - Dimension.containerMaxWidth * 0.6 * 1.2) / 2;
    double screenWidth = Dimension.containerMaxWidth * 0.6;
    double screenBorderWidth = Dimension.containerMaxWidth * 0.015;
    double screenBorderMargin = Dimension.containerMaxWidth * 0.054;
    double screenHeight = Dimension.containerMaxWidth * 0.6 * 1.2;

    TextComponent titleText = TextComponent(
      position: Vector2(size.x / 2, screenTop - screenBorderMargin - screenBorderWidth / 2),
      text: Strings.appName,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
    );
    //
    double borderLeft = screenLeft - screenBorderMargin - screenBorderWidth;
    double topMargin = screenTop - screenBorderMargin + Dimension.blackBlockSize / 4;
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
    double rightX = screenLeft + screenWidth + screenBorderMargin + screenBorderWidth + leftX;
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
    double gameMargin = (screenHeight - Dimension.blackBlockSize * Dimension.blackBlockRow) / 2;
    addAll([
      titleText,
      ...blackBlocks,
      AreaGame(
        position: Vector2(
          screenLeft + gameMargin,
          screenTop + gameMargin,
        ),
      ),
      AreaData(
        position: Vector2(
          screenLeft +
              gameMargin +
              Dimension.blackBlockSize * Dimension.blackBlockColumn +
              Dimension.blackBlockPadding * 4 +
              gameMargin * 0.5,
          screenTop + gameMargin,
        ),
        size: Vector2(
          screenWidth -
              gameMargin -
              Dimension.blackBlockSize * Dimension.blackBlockColumn -
              Dimension.blackBlockPadding * 4 -
              gameMargin,
          screenHeight - gameMargin * 2,
        ),
      ),
    ]);
  }
}

class ContainerComponentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double screenLeft = Dimension.containerMaxWidth * 0.4 / 2;
    double screenTop = (size.height - Dimension.containerMaxWidth * 0.6 * 1.2) / 2;
    double screenWidth = Dimension.containerMaxWidth * 0.6;
    double screenHeight = Dimension.containerMaxWidth * 0.6 * 1.2;
    // screen background
    canvas.drawRect(
      Rect.fromLTWH(screenLeft, screenTop, screenWidth, screenHeight),
      const PaletteEntry(Color(ColorsValue.screenBg)).paint(),
    );
    // screen shadow
    double screenShadowWidth = Dimension.containerMaxWidth * 0.0075;
    Paint screenShadowPaint = Paint();
    screenShadowPaint.color = const Color(ColorsValue.screenShadow);
    screenShadowPaint.strokeWidth = screenShadowWidth;
    canvas.drawLine(
      Offset(screenLeft - screenShadowWidth, screenTop - screenShadowWidth / 2),
      Offset(
        screenLeft + screenWidth + screenShadowWidth,
        screenTop - screenShadowWidth / 2,
      ),
      screenShadowPaint,
    );
    canvas.drawLine(
      Offset(screenLeft - screenShadowWidth / 2, screenTop - screenShadowWidth),
      Offset(screenLeft - screenShadowWidth / 2, screenTop + screenHeight + screenShadowWidth),
      screenShadowPaint,
    );
    canvas.drawLine(
      Offset(
        screenLeft - screenShadowWidth,
        screenTop + screenHeight + screenShadowWidth / 2,
      ),
      Offset(
        screenLeft + screenWidth + screenShadowWidth,
        screenTop + screenHeight + screenShadowWidth / 2,
      ),
      screenShadowPaint,
    );
    canvas.drawLine(
      Offset(
        screenLeft + screenWidth + screenShadowWidth / 2,
        screenTop - screenShadowWidth,
      ),
      Offset(
        screenLeft + screenWidth + screenShadowWidth / 2,
        screenTop + screenHeight + screenShadowWidth,
      ),
      screenShadowPaint,
    );
    // screen inner border
    Paint innerBorderPaint = Paint();
    innerBorderPaint.style = PaintingStyle.stroke;
    innerBorderPaint.color = Colors.black;
    canvas.drawRect(
      Rect.fromLTWH(screenLeft, screenTop, screenWidth, screenHeight),
      innerBorderPaint,
    );

    double screenBorderWidth = Dimension.containerMaxWidth * 0.015;
    double screenBorderMargin = Dimension.containerMaxWidth * 0.054;
    // left border of screen
    canvas.drawRect(
      Rect.fromLTWH(
        screenLeft - screenBorderMargin - screenBorderWidth,
        screenTop - screenBorderMargin,
        screenBorderWidth,
        screenHeight + screenBorderMargin * 2 + screenBorderWidth,
      ),
      BasicPalette.black.paint(),
    );
    // right border of screen
    canvas.drawRect(
      Rect.fromLTWH(
        screenLeft + screenWidth + screenBorderMargin,
        screenTop - screenBorderMargin,
        screenBorderWidth,
        screenHeight + screenBorderMargin * 2 + screenBorderWidth,
      ),
      BasicPalette.black.paint(),
    );
    // bottom border of screen
    canvas.drawRect(
      Rect.fromLTWH(
        screenLeft - screenBorderMargin,
        screenTop + screenHeight + screenBorderMargin,
        screenWidth + screenBorderMargin * 2,
        screenBorderWidth,
      ),
      BasicPalette.black.paint(),
    );
    // top border of screen
    canvas.drawRect(
      Rect.fromLTWH(
        screenLeft - screenBorderMargin - screenBorderWidth,
        screenTop - screenBorderMargin - screenBorderWidth,
        screenBorderMargin + screenBorderWidth,
        screenBorderWidth,
      ),
      BasicPalette.black.paint(),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        screenLeft + screenWidth,
        screenTop - screenBorderMargin - screenBorderWidth,
        screenBorderMargin + screenBorderWidth,
        screenBorderWidth,
      ),
      BasicPalette.black.paint(),
    );
    // top-left point border
    for (var i = 1; i <= 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          screenLeft + screenBorderWidth * 2 * i - screenBorderWidth,
          screenTop - screenBorderMargin - screenBorderWidth,
          screenBorderWidth,
          screenBorderWidth,
        ),
        BasicPalette.black.paint(),
      );
    }
    // top-right point border
    for (var i = 1; i <= 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          screenLeft + screenWidth - screenBorderWidth * 2 * i,
          screenTop - screenBorderMargin - screenBorderWidth,
          screenBorderWidth,
          screenBorderWidth,
        ),
        BasicPalette.black.paint(),
      );
    }

    // game border
    double borderMargin =
        (screenHeight - Dimension.blackBlockSize * Dimension.blackBlockRow - Dimension.blackBlockPadding * 4) / 2;
    Paint gameBorderPaint = Paint();
    gameBorderPaint.style = PaintingStyle.stroke;
    gameBorderPaint.strokeWidth = 1;
    gameBorderPaint.color = Colors.black;
    canvas.drawRect(
      Rect.fromLTWH(
        screenLeft + borderMargin,
        screenTop + borderMargin,
        Dimension.blackBlockSize * Dimension.blackBlockColumn + Dimension.blackBlockPadding * 4,
        Dimension.blackBlockSize * Dimension.blackBlockRow + Dimension.blackBlockPadding * 4,
      ),
      gameBorderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
