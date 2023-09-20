import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/colors_value.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';

class BlackBlock extends CustomPainterComponent {
  BlackBlock({super.position, this.status = BlackBlockStatus.black});

  BlackBlockStatus status;

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(Dimension.blackBlockSize);
    painter = BlackBlockPainter(status: status);
  }
}

class BlackBlockPainter extends CustomPainter {
  BlackBlockPainter({required this.status});
  BlackBlockStatus status;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = BasicPalette.black.paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = status == BlackBlockStatus.black
        ? Colors.black
        : const Color(ColorsValue.blockGrey);
    canvas.drawRect(
      Rect.fromLTWH(
        Dimension.blackBlockPadding,
        Dimension.blackBlockPadding,
        size.width - Dimension.blackBlockPadding * 2,
        size.height - Dimension.blackBlockPadding * 2,
      ),
      paint,
    );

    canvas.drawRect(
      const Rect.fromLTWH(
        (Dimension.blackBlockSize - Dimension.blackBlockInnerSize) / 2,
        (Dimension.blackBlockSize - Dimension.blackBlockInnerSize) / 2,
        Dimension.blackBlockInnerSize,
        Dimension.blackBlockInnerSize,
      ),
      PaletteEntry(status == BlackBlockStatus.black
              ? Colors.black
              : const Color(ColorsValue.blockGrey))
          .paint(),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum BlackBlockStatus { black, grey }
