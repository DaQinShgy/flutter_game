import 'dart:ui';

import 'package:flame/components.dart';

class FlipSprite extends Sprite {
  FlipSprite(super.image, this.flip, {super.srcPosition, super.srcSize});

  final bool flip;

  @override
  void render(
    Canvas canvas, {
    Vector2? position,
    Vector2? size,
    Anchor anchor = Anchor.topLeft,
    Paint? overridePaint,
  }) {
    if (flip && size != null) {
      canvas.scale(-1, 1);
      canvas.translate(-size.x, 0);
    }
    super.render(canvas,
        position: position,
        size: size,
        anchor: anchor,
        overridePaint: overridePaint);
  }
}
