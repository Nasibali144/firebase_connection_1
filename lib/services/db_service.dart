import 'dart:convert';

import 'package:firebase_connection_1/models/post_model.dart';
import 'package:firebase_connection_1/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';

sealed class DBService {
  static final db = FirebaseDatabase.instance;

  static Future<void> storePost(String title, String content, bool isPublic) async {
    final folder = db.ref(Folder.post);
    final child = folder.push();
    final id = child.key!;
    final userId = AuthService.user.uid;

    final post = Post(id: id, title: title, content: content, userId: userId, isPublic: isPublic);
    await child.set(post.toJson());
  }

  static Future<List<Post>> readAllPost() async{
    final folder = db.ref(Folder.post);
    final data = await folder.get();
    final json = jsonDecode(jsonEncode(data.value)) as List;
    return json.map((e) => Post.fromJson(e as Map<String, Object?>)).toList();
  }
}

sealed class Folder {
  static const post = "Post";
}