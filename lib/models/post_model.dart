class Post {
  final String id;
  final String title;
  final String content;
  final String userId;
  final bool isPublic;

  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.isPublic,
  });

  factory Post.fromJson(Map<String, Object?> json) {
    return Post(
      id: json["id"] as String,
      title: json["title"] as String,
      content: json["content"] as String,
      userId: json["userId"] as String,
      isPublic: json["isPublic"] as bool,
    );
  }

  Map<String, Object?> toJson() => {
    "id" : id,
    "title" : title,
    "content" : content,
    "userId" : userId,
    "isPublic" : isPublic,
  };
}
