import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter_game/tetris/constants/dimension.dart';
import 'package:flutter_game/tetris/objects/app_container.dart';

class TerisGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await images.loadAll(['tetris.png']);
    AppContainer appContainer = AppContainer(
      position: size / 2,
      size: Vector2(Dimension.containerMaxWidth, size.y),
      anchor: Anchor.center,
      paint: BasicPalette.transparent.paint(),
    );
    add(appContainer);
  }

  @override
  Color backgroundColor() => const Color(0xFF009688);
}
