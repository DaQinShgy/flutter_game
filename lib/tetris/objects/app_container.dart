import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_event.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/constants/strings.dart';
import 'package:flutter_game/tetris/objects/area_control.dart';
import 'package:flutter_game/tetris/objects/container_component.dart';

import 'container_bg.dart';

class AppContainer extends RectangleComponent with FlameBlocListenable<StatsBloc, StatsState> {
  AppContainer({
    super.position,
    super.size,
    super.anchor,
    super.paint,
  });

  late ContainerComponent containerComponent;

  @override
  FutureOr<void> onLoad() async {
    ContainerBg containerBg = ContainerBg(size: super.size);
    containerComponent = ContainerComponent(
      size: Vector2(
        size.x,
        Dimension.screenMarginTop +
            Dimension.screenMaxHeight +
            Dimension.screenBorderMargin +
            Dimension.screenBorderWidth,
      ),
    );
    AreaControl areaControl = AreaControl(
      position: Vector2(
        Dimension.controlHorizontalMargin,
        Dimension.screenMarginTop +
            Dimension.screenMaxHeight +
            Dimension.screenBorderMargin +
            Dimension.screenBorderWidth,
      ),
      size: Vector2(
        Dimension.containerMaxWidth - Dimension.controlHorizontalMargin * 2,
        size.y - Dimension.screenMaxHeight - Dimension.screenBorderMargin - Dimension.screenMarginTop,
      ),
    );
    addAll([containerBg, containerComponent, areaControl]);
  }

  bool firstUpdate = true;

  @override
  void update(double dt) {
    if (firstUpdate) {
      firstUpdate = false;
      bloc.on<DropShake>((event, emit) async {
        containerComponent.position =
            Vector2(containerComponent.position.x, containerComponent.position.y + Dimension.dropShake);
        await Future.delayed(const Duration(milliseconds: 50));
        containerComponent.position =
            Vector2(containerComponent.position.x, containerComponent.position.y - Dimension.dropShake);
      });
    }
  }
}
