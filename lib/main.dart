import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/menu_button.dart';
import 'package:flutter_game/tetris/tetris_game.dart';

void main() {
  runApp(const MaterialApp(
    home: GameMenu(),
  ));
}

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GameMenuState();
  }
}

class _GameMenuState extends State<GameMenu> {
  final List<String> games = ['Tetris', 'Mario'];

  int selectIndex = 0;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flutter Game',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 20),
            RawKeyboardListener(
              focusNode: _focusNode,
              autofocus: true,
              onKey: (RawKeyEvent event) {
                if (event is RawKeyUpEvent) {
                  return;
                }
                if (event.data.logicalKey == LogicalKeyboardKey.arrowDown) {
                  if (selectIndex < games.length - 1) {
                    selectIndex++;
                  } else {
                    selectIndex = 0;
                  }
                } else if (event.data.logicalKey ==
                    LogicalKeyboardKey.arrowUp) {
                  if (selectIndex <= 0) {
                    selectIndex = games.length - 1;
                  } else {
                    selectIndex--;
                  }
                } else if (event.data.logicalKey == LogicalKeyboardKey.enter) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(
                          game: selectIndex == 0 ? TetrisGame() : MarioGame()),
                    ),
                  );
                }
                setState(() {});
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildMenu(),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  List<MenuButton> _buildMenu() {
    return games
        .asMap()
        .entries
        .map((e) => MenuButton(
              text: e.value,
              isSelected: selectIndex == e.key,
            ))
        .toList();
  }
}
