import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/tetris/objects/icon_colon.dart';
import 'package:flutter_game/tetris/objects/icon_digital.dart';

class IconTime extends PositionComponent {
  IconTime({super.position}) : super(scale: Vector2(0.8, 0.8));

  late IconDigital digitalHour0;
  late IconDigital digitalHour1;

  late IconDigital digitalMinute0;
  late IconDigital digitalMinute1;

  @override
  FutureOr<void> onLoad() {
    digitalHour0 = IconDigital(digital: 0, position: Vector2(0, 0));
    digitalHour1 = IconDigital(digital: 0, position: Vector2(10, 0));
    digitalMinute0 = IconDigital(digital: 0, position: Vector2(30, 0));
    digitalMinute1 = IconDigital(digital: 0, position: Vector2(40, 0));
    addAll([
      digitalHour0,
      digitalHour1,
      IconColon(position: Vector2(20, 0)),
      digitalMinute0,
      digitalMinute1,
    ]);
  }

  @override
  void update(double dt) {
    DateTime now = DateTime.now();
    int hour0 = now.hour ~/ 10;
    if (hour0 != digitalHour0.digital) {
      digitalHour0.updateDigital(hour0);
    }
    int hour1 = now.hour % 10;
    if (hour1 != digitalHour1.digital) {
      digitalHour1.updateDigital(hour1);
    }
    int minute0 = now.minute ~/ 10;
    if (minute0 != digitalMinute0.digital) {
      digitalMinute0.updateDigital(minute0);
    }
    int minute1 = now.minute % 10;
    if (minute1 != digitalMinute1.digital) {
      digitalMinute1.updateDigital(minute1);
    }
  }
}
