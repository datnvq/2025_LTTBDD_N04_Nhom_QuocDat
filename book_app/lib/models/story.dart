class Chapter {
  final int id;
  final String title;
  final String content;

  Chapter({required this.id, required this.title, required this.content});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}

class Story {
  final int id;
  final String title;
  final String author;
  final List<Chapter> chapters;

  Story({
    required this.id,
    required this.title,
    required this.author,
    required this.chapters,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      chapters: (json['chapters'] as List)
          .map((c) => Chapter.fromJson(c))
          .toList(),
    );
  }
}
