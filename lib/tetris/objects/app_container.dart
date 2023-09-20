import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/constants/strings.dart';

import 'container_bg.dart';

class AppContainer extends RectangleComponent {
  AppContainer({
    super.position,
    super.size,
    super.anchor,
    super.paint,
  });

  @override
  FutureOr<void> onLoad() async {
    ContainerBg containerBg = ContainerBg(size: super.size);
    TextComponent titleText = TextComponent(
      position: Vector2(size.x / 2, Dimension.titleMarginTop),
      text: Strings.appName,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
    );
    addAll([containerBg, titleText]);
  }
}
