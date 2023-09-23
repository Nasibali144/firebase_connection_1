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

  static Future<bool> deletePost(String postId) async {
    try {
      final fbPost = db.ref(Folder.post).child(postId);
      await fbPost.remove();
      return true;
    } catch (e) {
      return false;
    }
   }

  static Future<bool> updatePost(String postId, String title, String content, bool isPublic) async {
    try {
      final fbPost = db.ref(Folder.post).child(postId);
      await fbPost.update({
        "title": title,
        "content": content,
        "isPublic": isPublic
      });

      // fbPost.set(post.toJson());
      return true;
    } catch(e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }

  static Future<List<Post>> searchPost(String text, [SearchType type = SearchType.all]) async {
    try{
      final folder = db.ref(Folder.post);
      final event =  await folder.orderByChild("title").startAt(text).endAt("$text\uf8ff").once();
      final json = jsonDecode(jsonEncode(event.snapshot.value)) as Map;
      debugPrint("JSON: $json");
      final data = json.values.map((e) => Post.fromJson(e as Map<String, Object?>)).toList();
      switch(type) {
        case SearchType.all: return data.where((element) => element.isPublic == true).toList();
        case SearchType.me: return data.where((element) => element.userId == AuthService.user.uid).toList();
      }
    } catch(e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }


  static Future<List<Post>> publicPost([bool isPublic = true]) async {
    try{
      final folder = db.ref(Folder.post);
      final event =  await folder.orderByChild("isPublic").equalTo(isPublic).once();
      final json = jsonDecode(jsonEncode(event.snapshot.value)) as Map;
      debugPrint("JSON: $json");
      return json.values.map((e) => Post.fromJson(e as Map<String, Object?>)).toList();
    } catch(e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Post>> myPost() async {
    try{
      final folder = db.ref(Folder.post);
      final event =  await folder.orderByChild("userId").equalTo(AuthService.user.uid).once();
      final json = jsonDecode(jsonEncode(event.snapshot.value)) as Map;
      debugPrint("JSON: $json");
      return json.values.map((e) => Post.fromJson(e as Map<String, Object?>)).toList();
    } catch(e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }
}

sealed class Folder {
  static const post = "Post";
}

enum SearchType {
  all,
  me,
}