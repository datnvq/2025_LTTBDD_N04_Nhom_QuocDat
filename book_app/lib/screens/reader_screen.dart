import 'package:flutter/material.dart';
import '../models/story.dart';

class ReaderScreen extends StatelessWidget {
  final Chapter chapter;

  const ReaderScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chapter.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            chapter.content,
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
        ),
      ),
    );
  }
}
