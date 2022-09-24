import 'dart:math';
import 'package:flutter/material.dart';

class Guess extends StatefulWidget {
  const Guess({Key? key}) : super(key: key);

  @override
  State<Guess> createState() => _GuessState();
}

enum Result {
  tooHigh,
  tooLow,
  correct
}

class Game {
  static const defaultMaxRandom = 100;
  int? _answer;
  int _guessCount = 0;
  static final List<int> guessCountList = [];

  Game({int maxRandom = defaultMaxRandom}) {
    var r = Random();
    _answer = r.nextInt(maxRandom) + 1;
    print('The answer is $_answer');
  }

  int get guessCount {
    return _guessCount;
  }

  void addCountList() {
    guessCountList.add(_guessCount);
  }

  Result doGuess(int num) {
    _guessCount++;
    if (num > _answer!) {
      return Result.tooHigh;
    } else if (num < _answer!) {
      return Result.tooLow;
    } else {
      return Result.correct;
    }
  }
}


class _GuessState extends State<Guess> {
  final Game _game = Game(maxRandom: 100);
  Result _result = Result.correct;
  String _resultStr = "Guess a number from 1 to 100";
  final Color _lightPurple = const Color.fromARGB(255, 243, 229, 245);
  String _input = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "GUESS THE NUMBER",
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              color: _lightPurple,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(5, 9), // changes position of shadow
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Image.asset(
                    'assets/game_logo.png',
                  ),*/
                  Column(
                    children: const [
                      Text("GUESS",
                          style: TextStyle(
                              fontSize: 36,
                              color: Color.fromARGB(255, 206, 147, 216))),
                      Text(
                        "THE NUMBER",
                        style: TextStyle(fontSize: 18, color: Colors.purple),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 64,
              ),
              Text(
                _input,
                style: const TextStyle(fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _resultStr,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [for (int i = 1; i <= 3; ++i) _buildNumberButton(i)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [for (int i = 4; i <= 6; ++i) _buildNumberButton(i)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [for (int i = 7; i <= 9; ++i) _buildNumberButton(i)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberButton(-2),
                  _buildNumberButton(0),
                  _buildNumberButton(-1)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      String str = _input;
                      _result = _game.doGuess(int.parse(_input));
                      switch (_result) {
                        case Result.tooLow:
                          _input = "";
                          _resultStr = "$str : Too Low";
                          break;
                        case Result.tooHigh:
                          _input = "";
                          _resultStr = "$str : Too High";
                          break;
                        case Result.correct:
                          if (_game.guessCount > 1) {
                            _resultStr =
                            "$str : Correct 🎉 ( ${_game.guessCount} attempts )";
                          } else {
                            _resultStr =
                            "$str : Correct 🎉 ( ${_game.guessCount} attempt )";
                          }

                      }

                      setState(() {});
                    },
                    child: const Text("GUESS")),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(int number) {
    Function buttonAction;

    Widget buttonChild;
    if (number == -1) {
      buttonAction = () {
        if (_input.isNotEmpty) {
          setState(() {
            _input = _input.substring(0, _input.length - 1);
          });
        }
      };
      buttonChild = const Icon(
        Icons.backspace_outlined,
        color: Colors.purple,
        size: 20,
      );
    } else if (number == -2) {
      buttonAction = () {
        setState(() {
          _input = "";
        });
      };
      buttonChild = const Icon(
        Icons.close,
        color: Colors.purple,
        size: 20,
      );
    } else {
      buttonAction = () {
        if (_input.length == 3) return;

        setState(() {
          _input += number.toString();
        });
      };
      buttonChild = Text(
        number.toString(),
        style: const TextStyle(color: Colors.purple, fontSize: 16),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => buttonAction(),
          child: Container(
            alignment: Alignment.center,
            width: 56,
            height: 32,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: const Color(0xFFCCCCCC), width: 1)),
            child: buttonChild,
          ),
        ),
      ),
    );
  }
}
