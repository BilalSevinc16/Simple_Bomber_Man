import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_bomber_man/button.dart';
import 'package:simple_bomber_man/pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberOfSquares = 100;
  int playerPosition = 0;
  int bombPosition = -1;
  List<int> barriers = [
    11,
    13,
    15,
    17,
    18,
    31,
    33,
    35,
    37,
    38,
    51,
    53,
    55,
    57,
    58,
    71,
    73,
    75,
    77,
    78,
    91,
    93,
    95,
    97,
    98,
  ];
  List<int> boxes = [
    12,
    14,
    16,
    28,
    21,
    41,
    61,
    81,
    83,
    63,
    65,
    67,
    47,
    39,
    19,
    1,
    30,
    50,
    70,
    96,
    79,
    99,
    7,
    3,
  ];

  void moveUp() {
    setState(() {
      if (playerPosition - 10 >= 0 &&
          !barriers.contains(playerPosition - 10) &&
          !boxes.contains(playerPosition - 10)) {
        playerPosition -= 10;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerPosition % 10 == 0) &&
          !barriers.contains(playerPosition - 1) &&
          !boxes.contains(playerPosition - 1)) {
        playerPosition -= 1;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(playerPosition % 10 == 9) &&
          !barriers.contains(playerPosition + 1) &&
          !boxes.contains(playerPosition + 1)) {
        playerPosition += 1;
      }
    });
  }

  void moveDown() {
    setState(() {
      if (playerPosition + 10 < numberOfSquares &&
          !barriers.contains(playerPosition + 10) &&
          !boxes.contains(playerPosition + 10)) {
        playerPosition += 10;
      }
    });
  }

  List<int> fire = [-1];

  void placeBomb() {
    setState(() {
      bombPosition = playerPosition;
      fire.clear();
      Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          fire.add(bombPosition);
          fire.add(bombPosition - 1);
          fire.add(bombPosition + 1);
          fire.add(bombPosition - 10);
          fire.add(bombPosition + 10);
        });
        clearFire();
      });
    });
  }

  void clearFire() {
    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          for (int i = 0; i < fire.length; i++) {
            if (boxes.contains(fire[i])) {
              boxes.remove(fire[i]);
            }
          }
          fire.clear();
          bombPosition = -1;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (fire.contains(index)) {
                    return MyPixel(
                      innerColor: Colors.red,
                      outerColor: Colors.red.shade900,
                    );
                  } else if (bombPosition == index) {
                    return MyPixel(
                      innerColor: Colors.green,
                      outerColor: Colors.green.shade800,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("images/pokeball.png"),
                      ),
                    );
                  } else if (playerPosition == index) {
                    return MyPixel(
                      innerColor: Colors.green,
                      outerColor: Colors.green.shade800,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset("images/bomberman.png"),
                      ),
                    );
                  } else if (barriers.contains(index)) {
                    return const MyPixel(
                      innerColor: Colors.black,
                      outerColor: Colors.black,
                    );
                  } else if (boxes.contains(index)) {
                    return MyPixel(
                      innerColor: Colors.brown,
                      outerColor: Colors.brown.shade800,
                    );
                  } else {
                    return MyPixel(
                      innerColor: Colors.green,
                      outerColor: Colors.green.shade800,
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyButton(),
                      MyButton(
                        function: moveUp,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 70,
                        ),
                      ),
                      const MyButton(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton(
                        function: moveLeft,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.arrow_left,
                          size: 70,
                        ),
                      ),
                      MyButton(
                        function: placeBomb,
                        color: Colors.grey.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "images/pokeball.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      MyButton(
                        function: moveRight,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.arrow_right,
                          size: 70,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyButton(),
                      MyButton(
                        function: moveDown,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 70,
                        ),
                      ),
                      const MyButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
