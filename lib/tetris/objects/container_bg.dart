import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/colors_value.dart';

class ContainerBg extends CustomPainterComponent {
  ContainerBg({super.size});

  @override
  FutureOr<void> onLoad() async {
    painter = ContainerBgPainter();
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
