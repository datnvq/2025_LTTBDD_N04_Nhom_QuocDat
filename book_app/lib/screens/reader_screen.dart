import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story.dart';

class ReaderScreen extends StatefulWidget {
  final List<Chapter> chapters;
  final int initialChapter;

  const ReaderScreen({
    super.key,
    required this.chapters,
    this.initialChapter = 0,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  double _fontSize = 18;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialChapter);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentPage = prefs.getInt("last_chapter") ?? widget.initialChapter;
      _fontSize = prefs.getDouble("font_size") ?? 18;
      _pageController = PageController(initialPage: _currentPage);
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("last_chapter", _currentPage);
    await prefs.setDouble("font_size", _fontSize);
  }

  @override
  void dispose() {
    _saveProgress();
    _pageController.dispose();
    super.dispose();
  }

  void _changeFontSize(bool increase) {
    setState(() {
      _fontSize += increase ? 2 : -2;
      if (_fontSize < 14) _fontSize = 14;
      if (_fontSize > 30) _fontSize = 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapters[_currentPage].title),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => _changeFontSize(false),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _changeFontSize(true),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.chapters.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
          _saveProgress();
        },
        itemBuilder: (context, index) {
          final chapter = widget.chapters[index];
          return Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.grey.shade100,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Text(
                chapter.content,
                style: TextStyle(
                  fontSize: _fontSize,
                  height: 1.6,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
