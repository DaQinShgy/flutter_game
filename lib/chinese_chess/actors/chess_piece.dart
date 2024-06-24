import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/chinese_chess/chess_game.dart';

class ChessPiece extends PositionComponent with HasGameRef<ChessGame> {
  ChessPiece(
    this._type, {
    super.size,
    super.position,
    super.anchor = Anchor.center,
  });

  final PieceType _type;

  ///是否先手
  // final Bool _isOffensive;

  final Map<PieceType, List<double>> _pieceVector = {
    PieceType.hongBing: [2, 1],
    PieceType.hongPao: [82, 1],
    PieceType.hongMa: [162, 1],
    PieceType.hongJu: [242, 1],
    PieceType.hongXiang: [322, 1],
    PieceType.hongShi: [402, 1],
    PieceType.hongShuai: [482, 1],
    PieceType.heiZu: [2, 81],
    PieceType.heiPao: [82, 81],
    PieceType.heiMa: [162, 81],
    PieceType.heiJu: [242, 81],
    PieceType.heiXiang: [322, 81],
    PieceType.heiShi: [402, 81],
    PieceType.heiShuai: [482, 81],
  };

  @override
  FutureOr<void> onLoad() {
    SpriteComponent spriteComponent = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('chinese_chess/pieces.png'),
        srcSize: Vector2(76, 78),
        srcPosition: Vector2(_pieceVector[_type]![0], _pieceVector[_type]![1]),
      ),
      size: size,
    );
    add(spriteComponent);

    // SpriteComponent shadowComponent = SpriteComponent(
    //   sprite: Sprite(
    //     game.images.fromCache('chinese_chess/shadow.png'),
    //     srcSize: Vector2(76, 78),
    //     srcPosition: Vector2(_pieceVector[_type]![0], _pieceVector[_type]![1]),
    //   ),
    //   size: size,
    // );
    // add(shadowComponent);
  }
}

enum PieceType {
  hongBing,
  hongPao,
  hongJu,
  hongMa,
  hongXiang,
  hongShi,
  hongShuai,
  heiZu,
  heiPao,
  heiJu,
  heiMa,
  heiXiang,
  heiShi,
  heiShuai
}
