import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/colors_value.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';

class BlackBlock extends CustomPainterComponent {
  BlackBlock({
    super.position,
    this.status = BlackBlockStatus.black,
  }) : super(size: Vector2.all(Dimension.blackBlockSize));

  BlackBlockStatus status;

  @override
  FutureOr<void> onLoad() async {
    painter = BlackBlockPainter(status: status);
  }
}

class BlackBlockPainter extends CustomPainter {
  BlackBlockPainter({required this.status});

  BlackBlockStatus status;

  @override
  void paint(Canvas canvas, Size size) {
    double blackBlockInnerSize = Dimension.blackBlockSize * 0.566;

    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = Dimension.blackBlockPadding * 0.93;
    paint.color = status == BlackBlockStatus.black
        ? Colors.black
        : status == BlackBlockStatus.grey
            ? const Color(ColorsValue.blockGrey)
            : const Color(ColorsValue.blockRed);
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
      Rect.fromLTWH(
        (Dimension.blackBlockSize - blackBlockInnerSize) / 2,
        (Dimension.blackBlockSize - blackBlockInnerSize) / 2,
        blackBlockInnerSize,
        blackBlockInnerSize,
      ),
      PaletteEntry(status == BlackBlockStatus.black
              ? Colors.black
              : status == BlackBlockStatus.grey
                  ? const Color(ColorsValue.blockGrey)
                  : const Color(ColorsValue.blockRed))
          .paint(),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum BlackBlockStatus { black, grey, red }
