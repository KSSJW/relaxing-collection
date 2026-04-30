import 'package:shared_preferences/shared_preferences.dart';

class BubbleSniperFunctions {
  final String bubbleSniperHighScore = "bubbleSniper_highScore";
  final String bubbleSniperLowestLatency = "bubbleSniper_lowestLatency";
  final String bubbleSniperDuration = "bubbleSniper_duration";
  
  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    
    return prefs.getInt(bubbleSniperHighScore) ?? 0;
  }

  void saveHighScore(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(bubbleSniperHighScore, value);
  }

  Future<int> getLowestLatency() async {
    final prefs = await SharedPreferences.getInstance();
    
    return prefs.getInt(bubbleSniperLowestLatency) ?? 0;
  }

  void saveLowestLatency(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(bubbleSniperLowestLatency, value);
  }

  Future<int> getDuration() async {
    final prefs = await SharedPreferences.getInstance();
    
    return prefs.getInt(bubbleSniperDuration) ?? 50;
  }

  void saveDuration(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(bubbleSniperDuration, value);
  }
}