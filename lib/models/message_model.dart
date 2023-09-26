class Message {
  final String id;
  final String message;
  final DateTime writtenAt;
  final String userId;
  final String? userImage;
  final String username;
  final bool isMe;

  const Message({
    required this.id,
    required this.message,
    required this.writtenAt,
    required this.userId,
    required this.userImage,
    required this.username,
    this.isMe = false,
  });

  factory Message.fromJson(Map<String, Object?> json, {bool isMe = true}) {
    return Message(
      id: json["id"] as String,
      message: json["message"] as String,
      writtenAt: DateTime.parse(json["writtenAt"] as String),
      userId: json["userId"] as String,
      userImage: json["userImage"] as String?,
      username: json["username"] as String,
      isMe: isMe,
    );
  }

  Map<String, Object?> toJson() => {
    "id": id,
    "message": message,
    "writtenAt": writtenAt.toIso8601String(),
    "userId": userId,
    "userImage": userImage,
    "username": username,
  };
}
