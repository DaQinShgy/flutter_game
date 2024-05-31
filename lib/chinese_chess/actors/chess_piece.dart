import 'dart:async';

import 'package:flame/components.dart';

class ChessPiece extends PositionComponent {
  ChessPiece({super.size, super.position});

  @override
  FutureOr<void> onLoad() {}
}

enum PieceType { bing, pao, ju, ma, xiang, shi, shuai }
