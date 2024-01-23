import 'dart:math';

import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  const MenuButton(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.onTap});

  final String text;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  State<StatefulWidget> createState() {
    return _MenuButtonState();
  }
}

class _MenuButtonState extends State<MenuButton> {
  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width / 2, 260);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: width,
        height: width * 0.2,
        margin: EdgeInsets.only(top: width * 0.1),
        padding: EdgeInsets.all(width * 0.03),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF4f3e2c),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFF120e10)
                : Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            border: Border.all(color: const Color(0xFFffb102), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
