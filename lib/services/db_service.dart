import 'dart:convert';

import 'package:firebase_connection_1/models/post_model.dart';
import 'package:firebase_connection_1/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

sealed class DBService {
  static final db = FirebaseDatabase.instance;

  static Future<bool> storePost(String title, String content, bool isPublic) async {
    try {
      final folder = db.ref(Folder.post);
      final child = folder.push();
      final id = child.key!;
      final userId = AuthService.user.uid;

      final post = Post(id: id, title: title, content: content, userId: userId, isPublic: isPublic);
      await child.set(post.toJson());
      return true;
    } catch(e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }

  static Future<List<Post>> readAllPost() async{
    final folder = db.ref(Folder.post);
    final data = await folder.get();
    final json = jsonDecode(jsonEncode(data.value)) as Map;
    return json.values.map((e) => Post.fromJson(e as Map<String, Object?>)).toList();
  }
}

sealed class Folder {
  static const post = "Post";
}