import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gameboard/constent.dart';
import 'package:gameboard/piece.dart';
import 'package:gameboard/pixal.dart';
import 'package:gameboard/values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
    colLength,
    (i) => List.generate(
          rowLength,
          (j) => null,
        ));

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  Piece currentPiece = Piece(type: Tetromino.L);
  int currentScore = 0;
  bool gameOver = false;
  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    Duration frameRate = const Duration(milliseconds: 600);
    gameLoop(frameRate);
  }

  gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        clearLines();
        checkLanding();
        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }
        currentPiece.removPiece(Direction.down);
      });
    });
  }

  bool CheckCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    return false;
  }

  void checkLanding() {
    if (CheckCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }

        // createNewPiece();
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  void moveLeft() {
    if (!CheckCollision(Direction.left)) {
      setState(() {
        currentPiece.removPiece(Direction.left);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void moveRight() {
    if (!CheckCollision(Direction.right)) {
      setState(() {
        currentPiece.removPiece(Direction.right);
      });
    }
  }

  void clearLines() {
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFull = true;
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }
      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(row, (index) => null);

        currentScore++;
      }
    }
  }

  bool isGameOver() {
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score is : $currentScore'),
          actions: [
            TextButton(
                onPressed: () {
                  resetGame();
                  Navigator.pop(context);
                },
                child: const Text('Play Agan')),
          ],
        );
      },
    );
  }

  void resetGame() {
    gameBoard =
        List.generate(colLength, (i) => List.generate(rowLength, (j) => null));
    gameOver = false;
    currentScore = 0;
    createNewPiece();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBlackColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowLength * colLength,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength),
                itemBuilder: (context, index) {
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;
                  if (currentPiece.position.contains(index)) {
                    return Pixal(
                      color: AppColors.kYellowColor,
                    );
                  } else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixal(
                      color: tetrominoColors[tetrominoType],
                    );
                  } else {
                    return Pixal(
                      color: AppColors.kgreyColor,
                    );
                  }
                },
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     resetGame();
            //   },
            //   style: ButtonStyle(
            //       backgroundColor:
            //           MaterialStateProperty.all(AppColors.kgreyColor),
            //       padding: MaterialStateProperty.all(
            //           const EdgeInsets.symmetric(horizontal: 30.0))),
            //   child: const Text(
            //     'Game Agan',
            //     style: TextStyle(color: AppColors.kWhiteColor),
            //   ),
            // ),
            Text(
              'Score : $currentScore',
              style: const TextStyle(color: AppColors.kWhiteColor),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: moveLeft,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.kWhiteColor,
                      )),
                  IconButton(
                      onPressed: rotatePiece,
                      icon: const Icon(
                        Icons.rotate_right,
                        color: AppColors.kWhiteColor,
                      )),
                  IconButton(
                      onPressed: moveRight,
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.kWhiteColor,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
