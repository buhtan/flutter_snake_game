// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_snake_game/food_pixel.dart';
import 'package:flutter_snake_game/snake_pixel.dart';

import 'blank_pixel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// ignore: camel_case_types
enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _MyHomePageState extends State<MyHomePage> {
  
  //constants
  // ignore: non_constant_identifier_names
  var current_Direction = snake_Direction.RIGHT;
  int score = 0;
  final int rowSize = 10;
  final int totalPixelSize = 100;
  int foodPos = 55;
  List<int> snakePos = [0, 1, 2];
  bool gameStarted = false;
  var myTextStyle = const TextStyle(color: Colors.white, fontSize: 30);

  //new game
  void newGame() {
    setState(() {
      foodPos = 55;
      snakePos = [0, 1, 2];
      gameStarted = false;
      current_Direction = snake_Direction.RIGHT;
    });
  }

  void startGame() {
    gameStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
        if (gameOver()) {
          timer.cancel();

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.green,
                  title: const Text('Game over!!'),
                  content: Text('Your score is :$score'),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        score = 0;
                        newGame();
                      },
                      child: const Text('New Game'),
                    )
                  ],
                );
              });
        }
      });
    });
  }

  void eatSnake() {
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalPixelSize);
      score += 1;
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  void moveSnake() {
    switch (current_Direction) {
      case snake_Direction.RIGHT:
        {
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }

        break;
      case snake_Direction.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }

        break;
      case snake_Direction.UP:
        {
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalPixelSize);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }

        break;
      case snake_Direction.DOWN:
        {
          if (snakePos.last + rowSize > totalPixelSize) {
            snakePos.add(snakePos.last + rowSize - totalPixelSize);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }

        break;
      default:
    }
    if (snakePos.last == foodPos) {
      eatSnake();
    } else {
      snakePos.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Column(
              children: [
                Text('Score', style: myTextStyle),
                Text(score.toString(), style: myTextStyle),
              ],
            ),
          )),
          Expanded(
              flex: 4,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      current_Direction != snake_Direction.UP) {
                    current_Direction = snake_Direction.DOWN;
                  } else if (details.delta.dy < 0 &&
                      current_Direction != snake_Direction.DOWN) {
                    current_Direction = snake_Direction.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      current_Direction != snake_Direction.LEFT) {
                    current_Direction = snake_Direction.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      current_Direction != snake_Direction.RIGHT) {
                    current_Direction = snake_Direction.LEFT;
                  }
                },
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize,
                  ),
                  itemCount: totalPixelSize,
                  itemBuilder: (BuildContext context, int index) {
                    if (snakePos.contains(index)) {
                      return const SnakePixel();
                    } else if (foodPos == index) {
                      return const FoodPixel();
                    } else {
                      return const BlankPixel();
                    }
                  },
                ),
              )),
          Expanded(
              child: Center(
            child: MaterialButton(
              onPressed: gameStarted ? () {} : startGame,
              color: gameStarted ? Colors.grey : Colors.green,
              child: const Text('PLAY'),
            ),
          )),
        ],
      ),
    );
  }
}
