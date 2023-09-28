import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/colors_value.dart';

class RoundButton extends CustomPainterComponent with TapCallbacks {
  RoundButton({
    required this.type,
    required this.click,
    super.position,
    super.size,
  });

  IconButtonType type;

  VoidCallback click;

  @override
  FutureOr<void> onLoad() {
    setPainter(false);
  }

  @override
  void onTapDown(TapDownEvent event) {
    setPainter(true);
  }

  @override
  void onTapUp(TapUpEvent event) {
    setPainter(false);
    click();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    setPainter(false);
    click();
  }

  void setPainter(bool isPressed) {
    painter = IconButtonPainter(
      colorValue: type == IconButtonType.green
          ? ColorsValue.buttonGreen
          : type == IconButtonType.red
              ? ColorsValue.buttonRed
              : ColorsValue.buttonBlue,
      opacity: isPressed ? 0.7 : 1,
    );
  }
}

class IconButtonPainter extends CustomPainter {
  IconButtonPainter({required this.colorValue, required this.opacity});
  int colorValue;
  double opacity;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      PaletteEntry(Color(colorValue).withOpacity(opacity)).paint(),
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      BasicPalette.black.paint()..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum IconButtonType { green, red, blue }
