class MarioVectors {
  //Vector of normal small Mario
  static const List<List<double>> normalSmallVector = [
    [178, 32, 12, 16],
  ];

  //Vector of normal small Mario walk
  static const List<List<double>> normalSmallWalkVector = [
    [80, 32, 15, 16],
    [96, 32, 16, 16],
    [112, 32, 16, 16],
  ];

  //Vector of normal small Mario skid
  static const List<List<double>> normalSmallSkidVector = [
    [130, 32, 14, 16],
  ];

  //Vector of normal small Mario jump
  static const List<List<double>> normalSmallJumpVector = [
    [144, 32, 16, 16],
  ];

  //Vector of normal small Mario pole slide
  static const List<List<double>> normalSmallPoleSlideVector = [
    [194, 32, 12, 16],
  ];

  //Vector of normal small Mario pole slide
  static const List<List<double>> normalSmallPoleSlideEndVector = [
    [210, 33, 12, 16],
  ];

  //Vector of small to big
  static const List<List<double>> smallToBigVector = [
    [320, 8, 16, 24],
    [178, 32, 12, 16],
    [320, 8, 16, 24],
    [178, 32, 12, 16],
    [320, 8, 16, 24],
    [176, 0, 16, 32],
    [178, 32, 12, 16],
    [320, 8, 16, 24],
    [176, 0, 16, 32],
    [178, 32, 12, 16],
    [176, 0, 16, 32],
  ];

  //Vector of big to small
  static const List<List<double>> bigToSmallVector = [
    [144, 0, 16, 32],
    [272, 2, 16, 29],
    [241, 33, 16, 16],
    [272, 2, 16, 29],
    [241, 33, 16, 16],
    [272, 2, 16, 29],
    [241, 33, 16, 16],
    [272, 2, 16, 29],
    [241, 33, 16, 16],
    [272, 2, 16, 29],
    [241, 33, 16, 16],
  ];

  //Vector of normal big Mario
  static const List<List<double>> normalBigVector = [
    [176, 0, 16, 32],
  ];

  //Vector of normal big Mario walk
  static const List<List<double>> normalBigWalkVector = [
    [81, 0, 16, 32],
    [97, 0, 15, 32],
    [113, 0, 15, 32],
  ];

  //Vector of normal big Mario skid
  static const List<List<double>> normalBigSkidVector = [
    [128, 0, 16, 32],
  ];

  //Vector of normal big Mario jump
  static const List<List<double>> normalBigJumpVector = [
    [144, 0, 16, 32],
  ];

  //Vector of normal big Mario pole slide
  static const List<List<double>> normalBigPoleSlideVector = [
    [193, 2, 16, 30],
  ];

  //Vector of normal big Mario pole slide
  static const List<List<double>> normalBigPoleSlideEndVector = [
    [209, 2, 16, 29],
  ];

  //Vector of Mario die
  static const List<List<double>> dieVector = [
    [160, 32, 15, 16],
  ];

  //Vector of big to fire
  static const List<List<double>> bigToFireFlowerVector = [
    [113, 48, 15, 32],
    [113, 192, 15, 32],
    [113, 240, 15, 32],
    [113, 144, 15, 32],
    [113, 48, 15, 32],
    [113, 192, 15, 32],
    [113, 240, 15, 32],
    [113, 144, 15, 32],
    [113, 48, 15, 32],
    [113, 192, 15, 32],
    [113, 240, 15, 32],
    [113, 144, 15, 32],
    [113, 48, 15, 32],
    [113, 192, 15, 32],
    [113, 240, 15, 32],
  ];

  //Vector of big to fire
  static const List<List<double>> bigToFireVector = [
    [113, 48, 15, 32],
    [113, 192, 15, 32],
    [113, 240, 15, 32],
    [113, 144, 15, 32],
  ];

  //Vector of big throw fireball
  static const List<List<double>> bigThrowVector = [
    [336, 48, 16, 32],
  ];

  //Vector of invincible small
  static const List<List<double>> invincibleSmallVector = [
    ...normalSmallVector,
    [178, 224, 12, 16],
    [178, 272, 12, 16],
    [178, 176, 12, 16],
  ];

  //Vector of invincible big
  static const List<List<double>> invincibleBigVector = [
    ...normalBigVector,
    [176, 192, 16, 32],
    [176, 240, 16, 32],
    [176, 144, 16, 32],
  ];

  //Vector of invincible small walk
  static const List<List<double>> invincibleSmallWalkVector = [
    [80, 32, 15, 16],
    [80, 224, 15, 16],
    [80, 272, 15, 16],
    [80, 176, 15, 16],
    [96, 32, 16, 16],
    [96, 224, 16, 16],
    [96, 272, 16, 16],
    [96, 176, 16, 16],
    [112, 32, 16, 16],
    [112, 224, 15, 16],
    [112, 272, 15, 16],
    [112, 176, 15, 16],
  ];

  //Vector of invincible big walk
  static const List<List<double>> invincibleBigWalkVector = [
    [81, 0, 16, 32],
    [81, 192, 16, 32],
    [81, 240, 16, 32],
    [81, 144, 16, 32],
    [97, 0, 15, 32],
    [97, 192, 15, 32],
    [97, 240, 15, 32],
    [97, 144, 15, 32],
    [113, 0, 15, 32],
    [113, 192, 15, 32],
    [113, 240, 15, 32],
    [113, 144, 15, 32],
  ];

  //Vector of invincible small skid
  static const List<List<double>> invincibleSmallSkidVector = [
    ...normalSmallSkidVector,
    [130, 224, 14, 16],
    [130, 272, 14, 16],
    [130, 176, 14, 16],
  ];

  //Vector of invincible big skid
  static const List<List<double>> invincibleBigSkidVector = [
    ...normalBigSkidVector,
    [128, 192, 16, 32],
    [128, 240, 16, 32],
    [128, 144, 16, 32],
  ];

  //Vector of invincible small jump
  static const List<List<double>> invincibleSmallJumpVector = [
    ...normalSmallJumpVector,
    [144, 224, 16, 16],
    [144, 272, 16, 16],
    [144, 176, 16, 16],
  ];

  //Vector of invincible big jump
  static const List<List<double>> invincibleBigJumpVector = [
    ...normalBigJumpVector,
    [144, 192, 16, 32],
    [144, 240, 16, 32],
    [144, 144, 16, 32],
  ];

  //Vector of fire big Mario
  static const List<List<double>> fireBigVector = [
    [176, 48, 16, 32],
  ];

  //Vector of fire big Mario walk
  static const List<List<double>> fireBigWalkVector = [
    [81, 48, 16, 32],
    [97, 48, 15, 32],
    [113, 48, 15, 32],
  ];

  //Vector of fire big Mario skid
  static const List<List<double>> fireBigSkidVector = [
    [128, 48, 16, 32],
  ];

  //Vector of fire big Mario jump
  static const List<List<double>> fireBigJumpVector = [
    [144, 48, 16, 32],
  ];

  //Vector of fire big Mario pole slide
  static const List<List<double>> fireBigPoleSlideVector = [
    [193, 50, 16, 29],
  ];

  //Vector of fire big Mario pole slide
  static const List<List<double>> fireBigPoleSlideEndVector = [
    [209, 50, 16, 29],
  ];
}
