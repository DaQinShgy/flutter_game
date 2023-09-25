import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/constants/strings.dart';
import 'package:flutter_game/tetris/objects/round_button.dart';

class AreaControl extends CustomPainterComponent {
  AreaControl({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: Dimension.controlTextSize,
      ),
    );
    RoundButton buttonPause = RoundButton(
      type: IconButtonType.green,
      position: Vector2(0, Dimension.controlVerticalMargin),
      size: Vector2.all(Dimension.buttonSizeSmall),
    );
    TextComponent textPause = TextComponent(
      position: Vector2(
        Dimension.buttonSizeSmall / 2,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeSmall +
            Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.pause,
      textRenderer: textPaint,
    );
    RoundButton buttonSounds = RoundButton(
      type: IconButtonType.green,
      position: Vector2(
        Dimension.buttonSizeSmall * 2,
        Dimension.controlVerticalMargin,
      ),
      size: Vector2.all(Dimension.buttonSizeSmall),
    );
    TextComponent textSounds = TextComponent(
      position: Vector2(
        Dimension.buttonSizeSmall / 2 + Dimension.buttonSizeSmall * 2,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeSmall +
            Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.sounds,
      textRenderer: textPaint,
    );
    RoundButton buttonReset = RoundButton(
      type: IconButtonType.red,
      position: Vector2(
        Dimension.buttonSizeSmall * 4,
        Dimension.controlVerticalMargin,
      ),
      size: Vector2.all(Dimension.buttonSizeSmall),
    );
    TextComponent textReset = TextComponent(
      position: Vector2(
        Dimension.buttonSizeSmall / 2 + Dimension.buttonSizeSmall * 4,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeSmall +
            Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.reset,
      textRenderer: textPaint,
    );
    RoundButton buttonDrop = RoundButton(
      type: IconButtonType.blue,
      position: Vector2(
        Dimension.buttonSizeSmall,
        Dimension.controlVerticalMargin * 3 + Dimension.buttonSizeSmall,
      ),
      size: Vector2.all(Dimension.buttonSizeLarge),
    );
    TextComponent textDrop = TextComponent(
      position: Vector2(
        Dimension.buttonSizeSmall + Dimension.buttonSizeLarge / 2,
        Dimension.controlVerticalMargin * 3 +
            Dimension.buttonSizeSmall +
            Dimension.buttonSizeLarge +
            Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.drop,
      textRenderer: textPaint,
    );
    RoundButton buttonRotation = RoundButton(
      type: IconButtonType.blue,
      position: Vector2(
        size.x - Dimension.buttonSizeMedium * 2,
        Dimension.controlVerticalMargin,
      ),
      size: Vector2.all(Dimension.buttonSizeMedium),
    );
    TextComponent textRotation = TextComponent(
      position: Vector2(
        size.x - Dimension.buttonSizeMedium + Dimension.controlTextMargin,
        Dimension.controlVerticalMargin + Dimension.controlTextMargin,
      ),
      text: Strings.rotation,
      textRenderer: textPaint,
    );
    RoundButton buttonDown = RoundButton(
      type: IconButtonType.blue,
      position: Vector2(
        size.x - Dimension.buttonSizeMedium * 2,
        Dimension.controlVerticalMargin + Dimension.buttonSizeMedium * 2,
      ),
      size: Vector2.all(Dimension.buttonSizeMedium),
    );
    TextComponent textDown = TextComponent(
      position: Vector2(
        size.x - Dimension.buttonSizeMedium * 1.5,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 3 +
            Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.down,
      textRenderer: textPaint,
    );
    RoundButton buttonLeft = RoundButton(
      type: IconButtonType.blue,
      position: Vector2(
        size.x - Dimension.buttonSizeMedium * 3,
        Dimension.controlVerticalMargin + Dimension.buttonSizeMedium,
      ),
      size: Vector2.all(Dimension.buttonSizeMedium),
    );
    TextComponent textLeft = TextComponent(
      position: Vector2(
        size.x - Dimension.buttonSizeMedium * 2.5,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 2 +
            Dimension.controlTextMargin,
      ),
      anchor: Anchor.topCenter,
      text: Strings.left,
      textRenderer: textPaint,
    );
    RoundButton buttonRight = RoundButton(
      type: IconButtonType.blue,
      position: Vector2(
        size.x - Dimension.buttonSizeMedium,
        Dimension.controlVerticalMargin + Dimension.buttonSizeMedium,
      ),
      size: Vector2.all(Dimension.buttonSizeMedium),
    );
    TextComponent textRight = TextComponent(
      position: Vector2(
        size.x - Dimension.buttonSizeMedium * 0.5,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 2 +
            Dimension.controlTextMargin,
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
  }
}

class AreaControlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = BasicPalette.black.paint();
    canvas.drawPath(
      getTrianglePath(
        size.width - Dimension.buttonSizeMedium * 1.5,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium +
            Dimension.controlTextMargin,
        size.width -
            Dimension.buttonSizeMedium * 1.5 -
            Dimension.controlTriangleWidth / 2,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium +
            Dimension.controlTextMargin +
            Dimension.controlTriangleHeight,
        size.width -
            Dimension.buttonSizeMedium * 1.5 +
            Dimension.controlTriangleWidth / 2,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium +
            Dimension.controlTextMargin +
            Dimension.controlTriangleHeight,
      ),
      paint,
    );
    canvas.drawPath(
      getTrianglePath(
        size.width - Dimension.buttonSizeMedium * 1.5,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 2 -
            Dimension.controlTextMargin,
        size.width -
            Dimension.buttonSizeMedium * 1.5 -
            Dimension.controlTriangleWidth / 2,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 2 -
            Dimension.controlTextMargin -
            Dimension.controlTriangleHeight,
        size.width -
            Dimension.buttonSizeMedium * 1.5 +
            Dimension.controlTriangleWidth / 2,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 2 -
            Dimension.controlTextMargin -
            Dimension.controlTriangleHeight,
      ),
      paint,
    );
    canvas.drawPath(
      getTrianglePath(
        size.width -
            Dimension.buttonSizeMedium * 2 +
            Dimension.controlTextMargin,
        Dimension.controlVerticalMargin + Dimension.buttonSizeMedium * 1.5,
        size.width -
            Dimension.buttonSizeMedium * 2 +
            Dimension.controlTextMargin +
            Dimension.controlTriangleHeight,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 1.5 +
            Dimension.controlTriangleWidth / 2,
        size.width -
            Dimension.buttonSizeMedium * 2 +
            Dimension.controlTextMargin +
            Dimension.controlTriangleHeight,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 1.5 -
            Dimension.controlTriangleWidth / 2,
      ),
      paint,
    );
    canvas.drawPath(
      getTrianglePath(
        size.width -
            Dimension.buttonSizeMedium -
            Dimension.controlTextMargin,
        Dimension.controlVerticalMargin + Dimension.buttonSizeMedium * 1.5,
        size.width -
            Dimension.buttonSizeMedium -
            Dimension.controlTextMargin -
            Dimension.controlTriangleHeight,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 1.5 +
            Dimension.controlTriangleWidth / 2,
        size.width -
            Dimension.buttonSizeMedium -
            Dimension.controlTextMargin -
            Dimension.controlTriangleHeight,
        Dimension.controlVerticalMargin +
            Dimension.buttonSizeMedium * 1.5 -
            Dimension.controlTriangleWidth / 2,
      ),
      paint,
    );
  }

  Path getTrianglePath(
      double x0, double y0, double x1, double y1, double x2, double y2) {
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
