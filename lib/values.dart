import 'package:flutter/material.dart';
import 'package:gameboard/constent.dart';

int rowLength = 10;
int colLength = 16;

enum Direction {
  left,
  right,
  down,
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

/*


O
O
O O

  O
  O
O O

O
O
O
O

O O
O O

   O O
O O 

O O
  O O

  O
  O O
  O

*/

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: AppColors.kOrangeColor,
  Tetromino.J: AppColors.kBlueColor,
  Tetromino.I: AppColors.kLuesColor,
  Tetromino.O: AppColors.kBlueOpastyColor,
  Tetromino.S: AppColors.kGreenColor,
  Tetromino.Z: AppColors.kRedColor,
  Tetromino.T: AppColors.kPurpleColor,
};
