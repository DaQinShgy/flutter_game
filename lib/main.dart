// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/chinese_chess/chess_game.dart';
import 'package:flutter_game/mario/mario_game.dart';
import 'package:flutter_game/menu_button.dart';
import 'package:flutter_game/tetris/constants/strings.dart';
import 'package:flutter_game/tetris/tetris_game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: GameMenu(),
    ),
  );
}

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GameMenuState();
  }
}

class _GameMenuState extends State<GameMenu> {
  late List<String> games;

  int selectIndex = 0;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    games = [
      AppLocalizations.of(context)!.tetris,
      AppLocalizations.of(context)!.mario,
      AppLocalizations.of(context)!.chineseChess
    ];
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.flutter_game,
              style: const TextStyle(color: Colors.black, fontSize: 20),
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
                  if (selectIndex == 0) {
                    Strings.appName = AppLocalizations.of(context)!.tetris;
                    Strings.highestScore =
                        AppLocalizations.of(context)!.highestScore;
                    Strings.score = AppLocalizations.of(context)!.score;
                    Strings.startLine = AppLocalizations.of(context)!.startLine;
                    Strings.cleanLine = AppLocalizations.of(context)!.cleanLine;
                    Strings.level = AppLocalizations.of(context)!.level;
                    Strings.next = AppLocalizations.of(context)!.next;
                    Strings.pause = AppLocalizations.of(context)!.pause;
                    Strings.sounds = AppLocalizations.of(context)!.sounds;
                    Strings.reset = AppLocalizations.of(context)!.reset;
                    Strings.drop = AppLocalizations.of(context)!.drop;
                    Strings.left = AppLocalizations.of(context)!.left;
                    Strings.right = AppLocalizations.of(context)!.right;
                    Strings.down = AppLocalizations.of(context)!.down;
                    Strings.rotation = AppLocalizations.of(context)!.rotation;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(
                          game: selectIndex == 0
                              ? TetrisGame()
                              : selectIndex == 1
                                  ? MarioGame()
                                  : ChessGame()),
                    ),
                  );
                }
                setState(() {});
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildMenu((index) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(
                          game: index == 0
                              ? TetrisGame()
                              : index == 1
                                  ? MarioGame()
                                  : ChessGame()),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  List<MenuButton> _buildMenu(void Function(int) onTap) {
    return games
        .asMap()
        .entries
        .mapIndexed((index, e) => MenuButton(
              text: e.value,
              isSelected: selectIndex == e.key,
              onTap: () {
                onTap(index);
              },
            ))
        .toList();
  }
}
