import 'dart:math';

import 'package:flutter/material.dart';

class BubbleCleaner extends StatefulWidget{
  const BubbleCleaner({super.key});

  @override
  State<StatefulWidget> createState() => BubbleCleanerState();
}

class BubbleCleanerState extends State<BubbleCleaner> {
  late Future _initFuture;

  final Random _random = Random();
  final int bubbleCount = 20;
  List<Offset> bubbles = [];

  Future<bool> _init() async {
    _generateInitialBubbles();

    return true;
  }

  void _generateInitialBubbles() {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final view = dispatcher.views.first; // 主视图
    final size = view.physicalSize / view.devicePixelRatio;

    bubbles = List.generate(
      bubbleCount,
      (_) => Offset(
        _random.nextDouble() * (size.width - 80),
        _random.nextDouble() * (size.height - 200),
      ),
    );
  }

  void _removeBubble(int index) {
    setState(() {
      bubbles.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();

    _initFuture = _init();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // TODO
      },
      child: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return Scaffold(
            appBar: AppBar(
              title: const Text("Bubble Cleaner"),
            ),
            body: Stack(
              children: [
                for (int i = 0; i < bubbles.length; i++) Positioned(
                  left: bubbles[i].dx,
                  top: bubbles[i].dy,
                  child: GestureDetector(
                    onTap: () => _removeBubble(i),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(153),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withAlpha(127),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}