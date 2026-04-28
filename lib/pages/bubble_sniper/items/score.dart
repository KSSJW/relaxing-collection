import 'package:flutter/material.dart';

class Score {

  Widget get(int score, int highScore, int latency, int currentLowestLatency, int lowestLatency) {
    return Positioned(
      top: 8,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Score"),
                SizedBox(height: 4.0),
                Text("Current: $score"),
                Text("Highest: $highScore"),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Latency (ms)"),
                SizedBox(height: 4.0),
                Text("Current: $latency"),
                Text("Current Lowest: $currentLowestLatency"),
                Text("Lowest: $lowestLatency"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}