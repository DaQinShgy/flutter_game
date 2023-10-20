import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class HudBackground extends PositionComponent {
  HudBackground({super.size});

  @override
  int priority = -1;

  late Paint paint;

  late final Rect hugeRect;

  @override
  Future<void> onLoad() async {
    paint = BasicPalette.black.paint();
    hugeRect = size.toRect();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(hugeRect, paint);
  }
}
