import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relaxing_collection/pages/bubble_sniper/bubble_sniper_functions.dart';
import 'package:relaxing_collection/pages/bubble_sniper/bubble_sniper_items.dart';
import 'package:relaxing_collection/pages/bubble_sniper_settings/bubble_sniper_settings.dart';

class BubbleSniper extends StatefulWidget {
  const BubbleSniper({super.key});

  @override
  State<StatefulWidget> createState() => BubbleSniperState();
}

class BubbleSniperState extends State<BubbleSniper> {
  late Future _initFuture;

  final Random _random = Random();
  double _x = 100;
  double _y = 100;
  int _duration = 50;
  bool _visible = true;
  bool _tapDown = false;

  int _score = 0;
  int _highScore = 0;

  final Stopwatch _stopwatch = Stopwatch();
  int _latency = 0;
  int _currentLowestLatency = 0;
  int _lowestLatency = 0;

  Future<bool> _init() async {
    final result = await Future.wait([
      /* 0 */ BubbleSniperFunctions().getHighScore(),
      /* 1 */ BubbleSniperFunctions().getLowestLatency(),
      /* 2 */ BubbleSniperFunctions().getDuration()
    ]);

    if (mounted) _moveBubble(context, false);

    setState(() {
      _highScore = result[0];
      _lowestLatency = result[1];
      _duration = result[2];
    });

    return true;
  }

  Future<void> _moveBubble(BuildContext context, bool initialized) async {
    if (_tapDown) return;

    _stopwatch.stop();
    _tapDown = true;

    int rawLatency = _stopwatch.elapsedMilliseconds;

    if (_duration != 0 && rawLatency != 0 && rawLatency < _duration) return;

    setState(() {
      _latency = rawLatency;

      if (_currentLowestLatency == 0) {
        _currentLowestLatency = _latency;
      } else {
        
        if (_latency < _currentLowestLatency) _currentLowestLatency = _latency;
      }

      _visible = false; // 触发消失动画
    });

    await Future.delayed(Duration(milliseconds: _duration));  // 等待动画完成

    if (!context.mounted) return;

    final size = MediaQuery.of(context).size;
    setState(() {
      _x = _random.nextDouble() * (size.width - 80);
      _y = _random.nextDouble() * (size.height - 200);
      _visible = true; // 新泡泡出现动画
      if (initialized) _score++;
    });

    Future.delayed(Duration(milliseconds: _duration), () {
      _tapDown = false; // 动画完成后解锁
    });
    
    _stopwatch.reset();
    _stopwatch.start();
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
        if (!didPop) return;

        if (_score > _highScore) BubbleSniperFunctions().saveHighScore(_score);

        if (_score > 0) {

          if (_lowestLatency == 0) {
            BubbleSniperFunctions().saveLowestLatency(_currentLowestLatency);
          } else {

            if (_currentLowestLatency < _lowestLatency) BubbleSniperFunctions().saveLowestLatency(_currentLowestLatency);
          }
        }
      },
      child: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return Scaffold(
            appBar: AppBar(
              title: const Text("Bubble Sniper"),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const BubbleSniperSettings())
                    );
                  },
                )
              ],
            ),
            body: Stack(
              children: [
                BubbleSniperItems.score.get(_score, _highScore, _latency, _currentLowestLatency, _lowestLatency),

                AnimatedPositioned(
                  duration: Duration(milliseconds: _duration),
                  left: _x,
                  top: _y,
                  child: GestureDetector(
                    onTap: () {
                      _moveBubble(context, true);
                    },
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: _duration),
                      opacity: _visible ? 1.0 : 0.0,
                      child: AnimatedScale(
                        duration: Duration(milliseconds: _duration),
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