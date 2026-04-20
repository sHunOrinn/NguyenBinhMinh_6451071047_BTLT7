class Post {
  final String? id;
  final String title;
  final String body;
  final String userId;

  Post({
    this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId']?.toString() ?? '',
    );
  }
}