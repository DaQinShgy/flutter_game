import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/chinese_chess/actors/chess_piece.dart';
import 'package:flutter_game/chinese_chess/chess_game.dart';

class ChessBoard extends SpriteComponent with HasGameRef<ChessGame> {
  ChessBoard({super.size, super.position, super.anchor});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('chinese_chess/chessboard.png'),
    );
    // 628 x 730
    // 41 669
    // 109.5 668
    // 178 668
    // 245.5 668
    // 68.5
    for (int i = 0; i < 9; i++) {
      ChessPiece piece = ChessPiece(
        PieceType.hongJu,
        size: Vector2(width / 10, width / 10 * 78 / 76),
        position: Vector2((41 + i * 68.5) / 628 * width, 669 / 730 * height),
      );
      add(piece);
    }
  }
}
