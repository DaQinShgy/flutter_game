import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class TestBg extends CustomPainterComponent {
  TestBg({super.position, super.size});

  @override
  FutureOr<void> onLoad() {
    painter = TestBgPainter();
  }
}

class TestBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const PaletteEntry(Color(0x80FF0000)).paint(),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
