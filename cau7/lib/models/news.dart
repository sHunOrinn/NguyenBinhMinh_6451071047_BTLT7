class News {
  final String id;
  final String title;
  final String content;
  final String image;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'image': image,
    };
  }
}