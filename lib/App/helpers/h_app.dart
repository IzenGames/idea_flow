import 'dart:convert';
import 'package:flutter/services.dart';

class HApp {
  Future<List<String>> loadStringArray() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/TestData/projects.json',
      );
      final List<dynamic> jsonArray = json.decode(jsonString);
      return jsonArray.cast<String>();
    } catch (e) {
      print('Error loading projects: $e');
      return [];
    }
  }
}
