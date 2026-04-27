import 'package:shared_preferences/shared_preferences.dart';

class BubbleBreakerFunctions {
  
  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    
    return prefs.getInt("bubble_breaker_highScore") ?? 0;
  }

  void saveHighScore(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("bubble_breaker_highScore", value);
  }
}