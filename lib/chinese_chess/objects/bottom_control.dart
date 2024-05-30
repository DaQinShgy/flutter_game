import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BottomControl extends RectangleComponent {
  BottomControl({super.size, super.position, super.anchor = Anchor.bottomLeft});

  @override
  FutureOr<void> onLoad() {
    setColor(Colors.black.withOpacity(0.3));
  }
}
