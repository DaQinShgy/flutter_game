import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_event.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/constants/strings.dart';
import 'package:flutter_game/tetris/objects/round_button.dart';

class AreaControl extends CustomPainterComponent with FlameBlocReader<StatsBloc, StatsState> {
  AreaControl({super.position, super.size});

  @override
  Future<void> onLoad() {
    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: Dimension.controlTextSize,
      ),
    );
    double buttonSizeSmall = Dimension.containerMaxWidth * 0.078;
    RoundButton buttonPause = RoundButton(
      type: IconButtonType.green,
      click: () {
        if (bloc.state.status == GameStatus.initial || bloc.state.status == GameStatus.pause) {
          bloc.add(const GameRunning());
        } else if (bloc.state.status == GameStatus.running) {
          bloc.add(const GamePause());
        }
      },
      position: Vector2(0, 0),
      size: Vector2.all(buttonSizeSmall),
    );
    TextComponent textPause = TextComponent(
      position: Vector2(
        buttonSizeSmall / 2,
        buttonSizeSmall + Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.pause,
      textRenderer: textPaint,
    );
    RoundButton buttonSounds = RoundButton(
      type: IconButtonType.green,
      click: () {
        bloc.add(const Mute());
      },
      position: Vector2(buttonSizeSmall * 2, 0),
      size: Vector2.all(buttonSizeSmall),
    );
    TextComponent textSounds = TextComponent(
      position: Vector2(
        buttonSizeSmall / 2 + buttonSizeSmall * 2,
        buttonSizeSmall + Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.sounds,
      textRenderer: textPaint,
    );
    RoundButton buttonReset = RoundButton(
      type: IconButtonType.red,
      click: () {
        if (bloc.state.status == GameStatus.initial) {
          bloc.add(const GameRunning());
        } else if (bloc.state.status == GameStatus.running ||
            bloc.state.status == GameStatus.pause ||
            bloc.state.status == GameStatus.mixing) {
          bloc.add(const GameReset());
        }
      },
      position: Vector2(buttonSizeSmall * 4, 0),
      size: Vector2.all(buttonSizeSmall),
    );
    TextComponent textReset = TextComponent(
      position: Vector2(
        buttonSizeSmall / 2 + buttonSizeSmall * 4,
        buttonSizeSmall + Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.reset,
      textRenderer: textPaint,
    );
    double buttonSizeLarge = Dimension.containerMaxWidth * 0.24688;
    RoundButton buttonDrop = RoundButton(
      type: IconButtonType.blue,
      click: () {
        if (bloc.state.status == GameStatus.initial || bloc.state.status == GameStatus.pause) {
          bloc.add(const GameRunning());
        } else if (bloc.state.status == GameStatus.running) {
          bloc.add(const Drop());
        }
      },
      position: Vector2(
        buttonSizeSmall / 2,
        size.y - buttonSizeLarge - Dimension.controlTextMargin - 20,
      ),
      size: Vector2.all(buttonSizeLarge),
    );
    TextComponent textDrop = TextComponent(
      position: Vector2(buttonSizeSmall / 2 + buttonSizeLarge / 2, size.y - 20),
      anchor: Anchor.topCenter,
      text: Strings.drop,
      textRenderer: textPaint,
    );
    double buttonSizeMedium = Dimension.containerMaxWidth * 0.15;
    double controlVerticalMargin = (size.y - buttonSizeMedium * 3) / 2;
    RoundButton buttonRotation = RoundButton(
      type: IconButtonType.blue,
      click: () {
        if (bloc.state.status == GameStatus.running) {
          bloc.add(const Rotation());
        } else if (bloc.state.status == GameStatus.initial) {
          bloc.add(const StartLineIncrease());
        }
      },
      position: Vector2(size.x - buttonSizeMedium * 2, controlVerticalMargin),
      size: Vector2.all(buttonSizeMedium),
    );
    TextComponent textRotation = TextComponent(
      position: Vector2(
        size.x - buttonSizeMedium,
        controlVerticalMargin + Dimension.controlTextMargin,
      ),
      text: Strings.rotation,
      textRenderer: textPaint,
    );
    RoundButton buttonDown = RoundButton(
      type: IconButtonType.blue,
      click: () {
        if (bloc.state.status == GameStatus.running) {
          bloc.add(const Down());
        } else if (bloc.state.status == GameStatus.initial) {
          bloc.add(const StartLineDecrease());
        }
      },
      position: Vector2(
        size.x - buttonSizeMedium * 2,
        controlVerticalMargin + buttonSizeMedium * 2,
      ),
      size: Vector2.all(buttonSizeMedium),
    );
    TextComponent textDown = TextComponent(
      position: Vector2(
        size.x - buttonSizeMedium * 1.5,
        controlVerticalMargin + buttonSizeMedium * 3 + Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.down,
      textRenderer: textPaint,
    );
    RoundButton buttonLeft = RoundButton(
      type: IconButtonType.blue,
      click: () {
        if (bloc.state.status == GameStatus.running) {
          bloc.add(const Left());
        } else if (bloc.state.status == GameStatus.initial) {
          bloc.add(const LevelDecrease());
        }
      },
      position: Vector2(
        size.x - buttonSizeMedium * 3,
        controlVerticalMargin + buttonSizeMedium,
      ),
      size: Vector2.all(buttonSizeMedium),
    );
    TextComponent textLeft = TextComponent(
      position: Vector2(
        size.x - buttonSizeMedium * 2.5,
        controlVerticalMargin + buttonSizeMedium * 2 + Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.left,
      textRenderer: textPaint,
    );
    RoundButton buttonRight = RoundButton(
      type: IconButtonType.blue,
      click: () {
        if (bloc.state.status == GameStatus.running) {
          bloc.add(const Right());
        } else if (bloc.state.status == GameStatus.initial) {
          bloc.add(const LevelIncrease());
        }
      },
      position: Vector2(
        size.x - buttonSizeMedium,
        controlVerticalMargin + buttonSizeMedium,
      ),
      size: Vector2.all(buttonSizeMedium),
    );
    TextComponent textRight = TextComponent(
      position: Vector2(
        size.x - buttonSizeMedium * 0.5,
        controlVerticalMargin + buttonSizeMedium * 2 + Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.right,
      textRenderer: textPaint,
    );
    addAll([
      buttonPause,
      textPause,
      buttonSounds,
      textSounds,
      buttonReset,
      textReset,
      buttonDrop,
      textDrop,
      buttonRotation,
      textRotation,
      buttonDown,
      textDown,
      buttonLeft,
      textLeft,
      buttonRight,
      textRight,
    ]);

    painter = AreaControlPainter();

    return super.onLoad();
  }
}

class AreaControlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double buttonSizeMedium = Dimension.containerMaxWidth * 0.153;
    double controlVerticalMargin = (size.height - buttonSizeMedium * 3) / 2;

    Paint paint = BasicPalette.black.paint();
    canvas.drawPath(
      getTrianglePath(
        size.width - buttonSizeMedium * 1.5,
        controlVerticalMargin + buttonSizeMedium + Dimension.controlTextMargin,
        size.width - buttonSizeMedium * 1.5 - Dimension.controlTriangleWidth / 2,
        controlVerticalMargin + buttonSizeMedium + Dimension.controlTextMargin + Dimension.controlTriangleHeight,
        size.width - buttonSizeMedium * 1.5 + Dimension.controlTriangleWidth / 2,
        controlVerticalMargin + buttonSizeMedium + Dimension.controlTextMargin + Dimension.controlTriangleHeight,
      ),
      paint,
    );
    canvas.drawPath(
      getTrianglePath(
        size.width - buttonSizeMedium * 1.5,
        controlVerticalMargin + buttonSizeMedium * 2 - Dimension.controlTextMargin,
        size.width - buttonSizeMedium * 1.5 - Dimension.controlTriangleWidth / 2,
        controlVerticalMargin + buttonSizeMedium * 2 - Dimension.controlTextMargin - Dimension.controlTriangleHeight,
        size.width - buttonSizeMedium * 1.5 + Dimension.controlTriangleWidth / 2,
        controlVerticalMargin + buttonSizeMedium * 2 - Dimension.controlTextMargin - Dimension.controlTriangleHeight,
      ),
      paint,
    );
    canvas.drawPath(
      getTrianglePath(
        size.width - buttonSizeMedium * 2 + Dimension.controlTextMargin,
        controlVerticalMargin + buttonSizeMedium * 1.5,
        size.width - buttonSizeMedium * 2 + Dimension.controlTextMargin + Dimension.controlTriangleHeight,
        controlVerticalMargin + buttonSizeMedium * 1.5 + Dimension.controlTriangleWidth / 2,
        size.width - buttonSizeMedium * 2 + Dimension.controlTextMargin + Dimension.controlTriangleHeight,
        controlVerticalMargin + buttonSizeMedium * 1.5 - Dimension.controlTriangleWidth / 2,
      ),
      paint,
    );
    canvas.drawPath(
      getTrianglePath(
        size.width - buttonSizeMedium - Dimension.controlTextMargin,
        controlVerticalMargin + buttonSizeMedium * 1.5,
        size.width - buttonSizeMedium - Dimension.controlTextMargin - Dimension.controlTriangleHeight,
        controlVerticalMargin + buttonSizeMedium * 1.5 + Dimension.controlTriangleWidth / 2,
        size.width - buttonSizeMedium - Dimension.controlTextMargin - Dimension.controlTriangleHeight,
        controlVerticalMargin + buttonSizeMedium * 1.5 - Dimension.controlTriangleWidth / 2,
      ),
      paint,
    );
  }

  Path getTrianglePath(double x0, double y0, double x1, double y1, double x2, double y2) {
    return Path()
      ..moveTo(x0, y0)
      ..lineTo(x1, y1)
      ..lineTo(x2, y2)
      ..lineTo(x0, y0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
