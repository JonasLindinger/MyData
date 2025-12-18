import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CustomPrefs {
  static Future<Map<String, dynamic>?> loadMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  static Future<void> saveMap(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }

  static Future<void> removeMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}