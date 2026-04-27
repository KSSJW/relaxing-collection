import 'dart:math';

import 'package:flutter/material.dart';
import 'package:relaxing_collection/pages/home/bubble_breaker/bubble_breaker_functions.dart';

class BubbleBreaker extends StatefulWidget {
  const BubbleBreaker({super.key});

  @override
  State<StatefulWidget> createState() => BubbleBreakerState();
}

class BubbleBreakerState extends State<BubbleBreaker> {
  late Future _initFuture;

  final Random _random = Random();
  double _x = 100;
  double _y = 100;
  bool _visible = true;
  bool _tapDown = false;

  int _score = 0;
  int _highScore = 0;

  Future<bool> _init() async {
    final result = await Future.wait([
      BubbleBreakerFunctions().getHighScore()
    ]);

    if (mounted) _moveBubble(context, false);

    setState(() {
      _highScore = result[0];
    });

    return true;
  }

  Future<void> _moveBubble(BuildContext context, bool initialized) async {
    if (_tapDown) return;

    _tapDown = true;

    setState(() {
      _visible = false; // 触发消失动画
    });

    await Future.delayed(const Duration(milliseconds: 100));  // 等待动画完成

    if (!context.mounted) return;

    final size = MediaQuery.of(context).size;
    setState(() {
      _x = _random.nextDouble() * (size.width - 80);
      _y = _random.nextDouble() * (size.height - 200);
      _visible = true; // 新泡泡出现动画
      if (initialized) _score++;
    });

    await Future.delayed(const Duration(milliseconds: 100));
    _tapDown = false; // 动画完成后解锁
  }

  @override
  void initState() {
    super.initState();

    _initFuture = _init();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _score > _highScore) BubbleBreakerFunctions().saveHighScore(_score);
      },
      child: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return Scaffold(
            appBar: AppBar(title: const Text("Bubble Breaker")),
            body: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Score: $_score    High Score: $_highScore",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  left: _x,
                  top: _y,
                  child: GestureDetector(
                    onTap: () {
                      _moveBubble(context, true);
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: _visible ? 1.0 : 0.0,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 100),
                        scale: _visible ? 1.0 : 0.0,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withAlpha(153) : Colors.blue.withAlpha(153),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.white.withAlpha(127) : Colors.blueAccent.withAlpha(127),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}