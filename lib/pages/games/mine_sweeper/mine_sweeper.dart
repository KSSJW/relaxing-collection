import 'dart:math';
import 'package:flutter/material.dart';

class MineSweeper extends StatefulWidget {
  const MineSweeper({super.key});

  @override
  State<MineSweeper> createState() => MineSweeperState();
}

class MineSweeperState extends State<MineSweeper> {
  static const int rows = 15;
  static const int cols = 10;
  static const int mineCount = 18;

  late List<List<Cell>> board;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _generateBoard();
  }

  void _generateBoard() {
    board = List.generate(rows, (_) => List.generate(cols, (_) => Cell()));
    _placeMines();
    _calculateNumbers();
  }

  void _placeMines() {
    final random = Random();
    int placed = 0;
    while (placed < mineCount) {
      int r = random.nextInt(rows);
      int c = random.nextInt(cols);
      if (!board[r][c].isMine) {
        board[r][c].isMine = true;
        placed++;
      }
    }
  }

  void _calculateNumbers() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c].isMine) continue;
        int count = 0;
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            int nr = r + dr;
            int nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              if (board[nr][nc].isMine) count++;
            }
          }
        }
        board[r][c].number = count;
      }
    }
  }

  void _reveal(int r, int c) {
    if (board[r][c].revealed || gameOver || board[r][c].flagged) return;
    setState(() {
      board[r][c].revealed = true;
      if (board[r][c].isMine) {
        gameOver = true;
      } else if (board[r][c].number == 0) {

        // 展开周围空格
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            int nr = r + dr;
            int nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              _reveal(nr, nc);
            }
          }
        }
      }
    });
  }

  bool _checkWin() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!board[r][c].isMine && !board[r][c].revealed) {
          return false;
        }
      }
    }
    return true;
  }

  void _toggleFlag(int r, int c) {
    if (board[r][c].revealed || gameOver) return;
    setState(() {
      board[r][c].flagged = !board[r][c].flagged;
    });
  }

  void _showFloatingMenu(BuildContext context, int r, int c, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem(
          child: const Text("Open"),
          onTap: () => _reveal(r, c),
        ),
        PopupMenuItem(
          child: const Text("Flag / Unflag"),
          onTap: () => _toggleFlag(r, c),
        ),
        PopupMenuItem(
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(gameOver ? "Game Over" : (_checkWin() ? "You Win!" :"Mine Sweeper"))),
      body: GridView.builder(
        itemCount: rows * cols,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
        ),
        itemBuilder: (context, index) {
          int r = index ~/ cols;
          int c = index % cols;
          Cell cell = board[r][c];
          return GestureDetector(
            onTapDown: (details) {
              _showFloatingMenu(context, r, c, details.globalPosition);
            },
            onSecondaryTap: () {
              _toggleFlag(r, c);
            },
            child: Container(
              margin: const EdgeInsets.all(1),
              color: cell.revealed
                ? (cell.isMine ? Colors.red : Colors.blueGrey)
                : Colors.blue,
              child: Center(
                child: cell.flagged
                  ? const Icon(Icons.flag, color: Colors.red)
                  : (cell.revealed && !cell.isMine
                    ? (cell.number > 0 ? Text("${cell.number}") : const SizedBox())
                    : (cell.revealed && cell.isMine)
                      ? const Icon(Icons.close)
                      : null),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Cell {
  bool isMine = false;
  bool revealed = false;
  bool flagged = false;
  int number = 0;
}