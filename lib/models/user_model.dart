class Member {
  final String uid;
  String username;
  String email;
  String password;
  String? userImg;
  String? phone;

  Member({
    required this.uid,
    required this.username,
    required this.email,
    required this.password,
    this.userImg,
    this.phone,
  });

  factory Member.fromJson(Map<String, Object?> json) {
    return Member(
      uid: json["uid"] as String,
      username: json["username"] as String,
      email: json["email"] as String,
      password: json["password"] as String,
      userImg: json["userImg"] as String?,
      phone: json["phone"] as String?,
    );
  }

  Map<String, Object?> toJson() => {
    "uid": uid,
    "username": username,
    "email": email,
    "password": password,
    "userImg": userImg,
    "phone": phone,
  };
}
