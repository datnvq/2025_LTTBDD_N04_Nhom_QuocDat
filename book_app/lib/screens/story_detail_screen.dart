import 'package:flutter/material.dart';
import '../models/story.dart';
import 'reader_screen.dart';

class StoryDetailScreen extends StatelessWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(story.title)),
      body: ListView.builder(
        itemCount: story.chapters.length,
        itemBuilder: (context, index) {
          final chapter = story.chapters[index];
          return ListTile(
            title: Text(chapter.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReaderScreen(chapter: chapter),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
