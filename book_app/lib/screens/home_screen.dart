import 'package:flutter/material.dart';
import '../models/story.dart';
import '../services/story_service.dart';
import 'story_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📖 App đọc truyện")),
      body: FutureBuilder<List<Story>>(
        future: StoryService.loadStories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final stories = snapshot.data!;
          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return ListTile(
                title: Text(story.title),
                subtitle: Text(story.author),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryDetailScreen(story: story),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
