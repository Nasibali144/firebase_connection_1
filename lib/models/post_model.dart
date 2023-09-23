class Post {
  final String id;
  final String title;
  final String content;
  final String userId;
  final String imageUrl;
  final bool isPublic;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.imageUrl,
    required this.isPublic,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, Object?> json) {
    return Post(
      id: json["id"] as String,
      title: json["title"] as String,
      content: json["content"] as String,
      userId: json["userId"] as String,
      imageUrl: json["imageUrl"] as String,
      isPublic: json["isPublic"] as bool,
      createdAt: DateTime.parse(json["createdAt"] as String),
    );
  }

  Map<String, Object?> toJson() => {
    "id" : id,
    "title" : title,
    "content" : content,
    "userId" : userId,
    "imageUrl" : imageUrl,
    "isPublic" : isPublic,
    "createdAt": createdAt.toIso8601String()
  };
}
