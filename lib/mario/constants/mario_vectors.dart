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

  //Vector of Mario die
  static const List<List<double>> dieVector = [
    [160, 32, 15, 16],
  ];
}
