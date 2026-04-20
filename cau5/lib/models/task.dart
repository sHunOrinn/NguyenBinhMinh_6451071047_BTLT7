class Task {
  final String id;
  final String title;
  final bool done;

  Task({
    required this.id,
    required this.title,
    required this.done,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      done: json['done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
    };
  }
}