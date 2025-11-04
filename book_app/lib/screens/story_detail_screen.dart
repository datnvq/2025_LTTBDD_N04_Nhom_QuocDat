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
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: story.chapters.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final chapter = story.chapters[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple.shade100,
              child: Text("${chapter.id}", style: const TextStyle(color: Colors.deepPurple)),
            ),
            title: Text(chapter.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReaderScreen(
                      chapters: story.chapters,
                      initialChapter: index,
                    ),
                  ),
                );
              }

          );
        },
      ),
    );
  }
}
