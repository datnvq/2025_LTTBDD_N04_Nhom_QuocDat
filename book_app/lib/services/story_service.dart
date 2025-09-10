import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/story.dart';

class StoryService {
  static Future<List<Story>> loadStories() async {
    final data = await rootBundle.loadString('assets/stories.json');
    final List<dynamic> jsonData = json.decode(data);
    return jsonData.map((s) => Story.fromJson(s)).toList();
  }
}
