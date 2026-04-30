import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

class Dino extends StatefulWidget {
  const Dino({super.key});

  @override
  State<Dino> createState() => DinoState();
}

class DinoState extends State<Dino> {
  double dinoHeight = 0; // 离地高度
  double velocity = 0;   // 垂直速度
  bool gameOver = false;
  List<double> obstacles = [];
  int score = 0;
  late Timer timer;
  final Random _random = Random();
  double width = 0.0;

  @override
  void initState() {
    super.initState();

    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final view = dispatcher.views.first; // 主视图
    final size = view.physicalSize / view.devicePixelRatio;
    width = size.width;

    timer = Timer.periodic(const Duration(milliseconds: 16), _update);
    _spawnObstacle();
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  void _update(Timer t) {
    if (!mounted || gameOver) return;
    setState(() {
      
      // 重力让速度减少
      velocity -= 0.8;
      dinoHeight += velocity;

      // 落地检测
      if (dinoHeight < 0) {
        dinoHeight = 0;
        velocity = 0;
      }

      // 障碍物移动
      for (int i = 0; i < obstacles.length; i++) {
        obstacles[i] -= 5;
      }
      obstacles.removeWhere((x) => x < -50);

      // 碰撞检测
      for (double x in obstacles) {
        if (x < 100 && x > 50 && dinoHeight == 0) {
          gameOver = true;
        }
      }
    });
  }

  void _jump() {
    if (dinoHeight == 0) {
      velocity = 14; // 正数表示向上跳
    }
  }

  void _spawnObstacle() {
    int duration = 500 + _random.nextInt(2000);
    Future.delayed(Duration(milliseconds: duration), () {
      if (!gameOver) {
        setState(() {
          obstacles.add(width); // 初始位置在屏幕右侧
          Future.delayed(Duration(milliseconds: duration), () => score++);
        });

        // 再次调用自己，形成循环
        _spawnObstacle();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: _jump,
        child: Scaffold(
          body: Stack(
            children: [
              // 恐龙
              Positioned(
                left: 50,
                bottom: dinoHeight + 100,
                child: SizedBox(width: 50, height: 50, child: const FlutterLogo()),
              ),
              // 障碍物
              for (double x in obstacles) Positioned(
                left: x,
                bottom: 100,
                child: Container(width: 30, height: 50, color: Colors.red),
              ),
              // 分数显示
              Positioned(
                top: 50,
                left: 20,
                child: Text(
                  "Score: $score",
                  style: const TextStyle(fontSize: 24)
                ),
              ),
              if (gameOver) const Center(
                child: Text(
                  "Game Over",
                  style: TextStyle(fontSize: 32)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}