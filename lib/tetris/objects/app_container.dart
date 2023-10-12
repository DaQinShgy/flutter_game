import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_bloc.dart';
import 'package:flutter_game/tetris/bloc/stats_event.dart';
import 'package:flutter_game/tetris/bloc/stats_state.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
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
      position: Vector2(0, (size.y - size.x * 1.4) / 4),
      size: Vector2(
        size.x,
        size.x * 0.9,
      ),
    );
    AreaControl areaControl = AreaControl(
      position: Vector2(
        Dimension.containerMaxWidth * 0.1,
        size.x * 0.9 + (size.y - size.x * 1.4) / 2,
      ),
      size: Vector2(
        Dimension.containerMaxWidth * 0.8,
        Dimension.containerMaxWidth * 0.55,
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
